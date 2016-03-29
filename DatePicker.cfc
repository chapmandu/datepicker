<cfcomponent output="false" mixin="controller">

	<cffunction name="init">
		<cfset this.version = "1.1.7,1.1.8,1.3,1.3.1,1.3.2,1.3.3,1.4,1.4.1,1.4.2,1.4.3,1.4.4">
		<cfreturn this>
	</cffunction>

	<!--- Place helper functions here that should be available for use in all view pages of your application --->
	<cffunction name="datePicker" access="public" output="false" returntype="string">
		<cfargument name="objectName" type="string" required="true">
		<cfargument name="property" type="string" required="true">
		<cfargument name="head" type="boolean" required="false" default="true">
		<cfset $args(name="datePicker", args=arguments)>
		<cfreturn $datePickerWriteOutput(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="datePickerTag" access="public" output="false" returntype="string">
		<cfargument name="name" type="string" required="true">
		<cfargument name="value" type="string" required="false" default="">
		<cfargument name="head" type="boolean" required="false" default="true">
		<cfset $args(name="datePickerTag", args=arguments)>
		<cfreturn $datePickerWriteOutput(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="$datePickerWriteOutput" access="public" output="false">
		<cfset var loc = {}>
		<cfset loc.dp = $datePicker(argumentCollection=arguments)>
		<!--- call wheels helper based on arguments supplied --->
		<cfif StructKeyExists(arguments,"objectName")>
			<cfset loc.return = textField(argumentCollection=loc.dp.helperArgs)>
		<cfelseif StructKeyExists(arguments,"name")>
			<cfset loc.return = textFieldTag(argumentCollection=loc.dp.helperArgs)>
		</cfif>
		<!--- deal with js output --->
		<cfif arguments.head>
			<cfhtmlhead text="#loc.dp.javascript#">
		<cfelse>
			<cfset loc.return = loc.dp.javascript & loc.return>
		</cfif>
		<cfreturn loc.return>
	</cffunction>

	<cffunction name="$datePicker" access="public" output="false">
		<cfset var loc = {}>
		<!--- default dateformat --->
		<cfset loc.dateFormat = "mm/dd/yy">

		<cfif StructKeyExists(arguments,"dateFormat")>
			<cfset loc.dateFormat = arguments.dateFormat>
		</cfif>

		<!--- the options available to me --->
		<cfset loc.availableOptions = "disabled,altField,altFormat,appendText,autoSize,buttonImage,buttonImageOnly,buttonText,calculateWeek,changeMonth,changeYear,closeText,constrainInput,currentText,dateFormat,dayNames,dayNamesMin,dayNamesShort,defaultDate,duration,firstDay,gotoCurrent,hideIfNoPrevNext,isRTL,maxDate,minDate,monthNames,monthNamesShort,navigationAsDateFormat,nextText,numberOfMonths,prevText,selectOtherMonths,shortYearCutoff,showAnim,showButtonPanel,showCurrentAtPos,showMonthAfterYear,showOn,showOptions,showOtherMonths,showWeek,stepMonths,weekHeader,yearRange,yearSuffix,onChangeMonthYear,onClose,onSelect">
		<!--- the arguments to pass to the cfwheels form helper function --->
		<cfset loc.helperArgs = Duplicate(arguments)>

		<!--- apply date formatting to the object property.. is this the correct way to manipulate an object within a plugin? --->
		<cfif StructKeyExists(arguments,"objectName")>
			<cfif StructKeyExists(variables[arguments.objectName], arguments.property)>
				<cfset loc.objectProperty = variables[arguments.objectName][arguments.property]>
			<cfelse>
				<cfset loc.objectProperty = "">
			</cfif>
			<cfif IsDate(loc.objectProperty)>
				<cfset variables[arguments.objectName][arguments.property] = DateFormat(loc.objectProperty, $datePickerMapDateMask(loc.dateFormat))>
			</cfif>
		<cfelseif StructKeyExists(arguments,"name")>
			<cfif IsDate(arguments.value)>
				<cfset loc.helperArgs.value = DateFormat(loc.helperArgs.value, $datePickerMapDateMask(loc.dateFormat))>
			</cfif>
		</cfif>

		<!--- build the datepicker options object --->
		<cfset loc.options = []>
		<cfset StructDelete(loc.helperArgs,"head")>
		<cfloop list="#loc.availableOptions#" index="loc.i">
			<!--- remove the datepicker options from the co --->
			<cfset StructDelete(loc.helperArgs,loc.i)>
			<!--- if it was supplied as an argument, use it --->
			<cfif StructKeyExists(arguments,loc.i)>
				<!--- wrap strings in single quotes.. this needs more robustness.. (there's that word again!) --->
				<cfif IsNumeric(arguments[loc.i])>
				<cfelseif Left(arguments[loc.i],1) IS "{" && Right(arguments[loc.i],1) IS "}">
				<cfelseif Left(arguments[loc.i],1) IS "[" && Right(arguments[loc.i],1) IS "]">
				<cfelseif ListFind("true,false", arguments[loc.i]) gt 0>
				<cfelseif ListFindNoCase("onChangeMonthYear,onClose,onSelect,beforeShowDay", loc.i) gt 0>
				<cfelse>
					<cfset arguments[loc.i] = "'#arguments[loc.i]#'">
				</cfif>
				<cfset ArrayAppend(loc.options,"#loc.i#:#arguments[loc.i]#")>
			</cfif>
		</cfloop>
		<!--- define a selector --->
		<cfif StructKeyExists(arguments,"id")>
			<cfset loc.selector = "###arguments.id#">
		<cfelseif StructKeyExists(arguments,"name")>
			<cfset loc.selector = "###arguments.name#">
		<cfelseif StructKeyExists(arguments,"objectName")>
			<cfset loc.selector = "###arguments.objectName#-#arguments.property#">
		</cfif>

		<!--- javascript --->
		<cfif ArrayLen(loc.options) gt 0>
			<cfset loc.javascriptOptions = "{#ArrayToList(loc.options, ", ")#}">
		<cfelse>
			<cfset loc.javascriptOptions = "">
		</cfif>
		<cfset loc.javascript = "<script>$(window).load(function() {$('#loc.selector#').datepicker(#loc.javascriptOptions#)});</script>">

		<cfreturn loc>
	</cffunction>

	<!--- map common jquery date masks to CF.. i'm sure this could be elegant-er (?) --->
	<cffunction name="$datePickerMapDateMask" access="public" output="false">
		<cfargument name="mask" required="true">
		<cfset var loc = {} />
		<!---
		datepicker
		==================================
		d - day of month (no leading zero)
		dd - day of month (two digit)
		D - day name short
		DD - day name long
		m - month of year (no leading zero)
		mm - month of year (two digit)
		M - month name short
		MM - month name long
		y - year (two digit)
		yy - year (four digit)

		CF
		==================================
		d: Day of the month as digits; no leading zero for single-digit days.
		dd: Day of the month as digits; leading zero for single-digit days.
		ddd: Day of the week as a three-letter abbreviation.
		dddd: Day of the week as its full name.
		m: Month as digits; no leading zero for single-digit months.
		mm: Month as digits; leading zero for single-digit months.
		mmm: Month as a three-letter abbreviation.
		mmmm: Month as its full name.
		yy: Year as last two digits; leading zero for years less than 10.
		yyyy: Year represented by four digits.
		gg: Period/era string. Ignored. Reserved. The following masks tell how to format the full date and cannot be combined with other masks:
		short: equivalent to m/d/y
		medium: equivalent to mmm d, yyyy
		long: equivalent to mmmm d, yyyy
		full: equivalent to dddd, mmmm d, yyyy
		 --->
		<cfset loc.return = Replace(arguments.mask,"y","yy","all")>
		<cfreturn loc.return>
	</cffunction>

</cfcomponent>
