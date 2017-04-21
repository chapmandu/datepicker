component output="false" mixin="controller" {

	public function init() {
		this.version = "2.0";
		return this;
	}

	public string function datePicker(
		required string objectName,
		required string property,
		boolean head="true"
	) {
		$args(name="datePicker", args=arguments);
		return $datePickerWriteOutput(argumentCollection=arguments);
	}

	public string function datePickerTag(
		required string name,
		string value="",
		boolean head="true"
	) {
		$args(name="datePickerTag", args=arguments);
		return $datePickerWriteOutput(argumentCollection=arguments);
	}

	public string function $datePickerWriteOutput() {
		local.dp = $datePicker(argumentCollection=arguments);
		//  call wheels helper based on arguments supplied
		if ( StructKeyExists(arguments,"objectName") ) {
			local.return = textField(argumentCollection=local.dp.helperArgs);
		} else if ( StructKeyExists(arguments,"name") ) {
			local.return = textFieldTag(argumentCollection=local.dp.helperArgs);
		}
		//  deal with js output
		if ( arguments.head ) {
			htmlhead text="#local.dp.javascript#";
		} else {
			local.return = local.dp.javascript & local.return;
		}
		return local.return;
	}

	public struct function $datePicker() {
		local.rv = {};
		//  default dateformat
		local.rv.dateFormat = "mm/dd/yy";
		if ( StructKeyExists(arguments, "dateFormat") ) {
			local.rv.dateFormat = arguments.dateFormat;
		}
		//  the options available to me
		local.rv.availableOptions = [
			"disabled",
			"altField",
			"altFormat",
			"appendText",
			"autoSize",
			"buttonImage",
			"buttonImageOnly",
			"buttonText",
			"calculateWeek",
			"changeMonth",
			"changeYear",
			"closeText",
			"constrainInput",
			"currentText",
			"dateFormat",
			"dayNames",
			"dayNamesMin",
			"dayNamesShort",
			"defaultDate",
			"duration",
			"firstDay",
			"gotoCurrent",
			"hideIfNoPrevNext",
			"isRTL",
			"maxDate",
			"minDate",
			"monthNames",
			"monthNamesShort",
			"navigationAsDateFormat",
			"nextText",
			"numberOfMonths",
			"prevText",
			"selectOtherMonths",
			"shortYearCutoff",
			"showAnim",
			"showButtonPanel",
			"showCurrentAtPos",
			"showMonthAfterYear",
			"showOn",
			"showOptions",
			"showOtherMonths",
			"showWeek",
			"stepMonths",
			"weekHeader",
			"yearRange",
			"yearSuffix",
			"onChangeMonthYear",
			"onClose",
			"onSelect"
		];
		//  the arguments to pass to the cfwheels form helper function
		local.rv.helperArgs = Duplicate(arguments);
		//  apply date formatting to the object property.. is this the correct way to manipulate an object within a plugin?
		if ( StructKeyExists(arguments,"objectName") ) {
			if ( StructKeyExists(variables[arguments.objectName], arguments.property) ) {
				local.rv.objectProperty = variables[arguments.objectName][arguments.property];
			} else {
				local.rv.objectProperty = "";
			}
			if ( IsDate(local.rv.objectProperty) ) {
				variables[arguments.objectName][arguments.property] = DateFormat(
					local.rv.objectProperty,
					$datePickerMapDateMask(local.rv.dateFormat)
				);
			}
		} else if ( StructKeyExists(arguments,"name") ) {
			if ( IsDate(arguments.value) ) {
				local.rv.helperArgs.value = DateFormat(local.rv.helperArgs.value, $datePickerMapDateMask(local.rv.dateFormat));
			}
		}
		//  build the datepicker options object
		local.rv.options = [];
		StructDelete(local.rv.helperArgs,"head");

		for (local.rv.i in local.rv.availableOptions) {
			//  remove the datepicker options from the co
			StructDelete(local.rv.helperArgs, local.rv.i);
			//  if it was supplied as an argument, use it
			if ( StructKeyExists(arguments, local.rv.i) ) {
				//  wrap strings in single quotes.. this needs more robustness.. (there's that word again!)
				if ( IsNumeric(arguments[local.rv.i]) ) {
				} else if ( Left(arguments[local.rv.i],1) == "{" && Right(arguments[local.rv.i],1) == "}" ) {
				} else if ( Left(arguments[local.rv.i],1) == "[" && Right(arguments[local.rv.i],1) == "]" ) {
				} else if ( ListFind("true,false", arguments[local.rv.i]) > 0 ) {
				} else if ( ListFindNoCase("onChangeMonthYear,onClose,onSelect,beforeShowDay", local.rv.i) > 0 ) {
				} else {
					arguments[local.rv.i] = "'#arguments[local.rv.i]#'";
				}
				ArrayAppend(local.rv.options,"#local.rv.i#:#arguments[local.rv.i]#");
			}
		}

		//  define a selector
		if ( StructKeyExists(arguments,"id") ) {
			local.rv.selector = "###arguments.id#";
		} else if ( StructKeyExists(arguments,"name") ) {
			local.rv.selector = "###arguments.name#";
		} else if ( StructKeyExists(arguments,"objectName") ) {
			local.rv.selector = "###arguments.objectName#-#arguments.property#";
		}
		//  javascript
		if ( ArrayLen(local.rv.options) ) {
			local.rv.javascriptOptions = "{#ArrayToList(local.rv.options, ", ")#}";
		} else {
			local.rv.javascriptOptions = "";
		}
		local.rv.javascript = "<script>$(window).load(function() {$('#local.rv.selector#').datepicker(#local.rv.javascriptOptions#)});</script>";
		return local.rv;
	}

	/**
	 * Map common jquery date masks to CF.. i'm sure this could be elegant-er (?)
	 *
	 * datepicker
	 * ==================================
	 * d - day of month (no leading zero)
	 * dd - day of month (two digit)
	 * D - day name short
	 * DD - day name long
	 * m - month of year (no leading zero)
	 * mm - month of year (two digit)
	 * M - month name short
	 * MM - month name long
	 * y - year (two digit)
	 * yy - year (four digit)
	 *
	 * CF
	 * ==================================
	 * d: Day of the month as digits; no leading zero for single-digit days.
	 * dd: Day of the month as digits; leading zero for single-digit days.
	 * ddd: Day of the week as a three-letter abbreviation.
	 * dddd: Day of the week as its full name.
	 * m: Month as digits; no leading zero for single-digit months.
	 * mm: Month as digits; leading zero for single-digit months.
	 * mmm: Month as a three-letter abbreviation.
	 * mmmm: Month as its full name.
	 * yy: Year as last two digits; leading zero for years less than 10.
	 * yyyy: Year represented by four digits.
	 * gg: Period/era string. Ignored. Reserved. The following masks tell how to format the full date and cannot be combined with other masks:
	 * short: equivalent to m/d/y
	 * medium: equivalent to mmm d, yyyy
	 * long: equivalent to mmmm d, yyyy
	 * full: equivalent to dddd, mmmm d, yyyy
	 *
	 * @mask a date format mask [d|dd|D|DD|m|mm|M|MM|y|yy]
	 */
	public string function $datePickerMapDateMask(required mask) {
		return Replace(arguments.mask, "y", "yy", "all");
	}

}
