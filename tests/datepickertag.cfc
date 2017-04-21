component extends="wheels.Test" {

	function setup() {
		//  save the orginal environment
		loc.orgApp = Duplicate(application);
		//  path to our plugins assets folder where we will store our components and files
		loc.assetsPath = "plugins/DatePicker/tests/assets";
		//  repoint the lookup paths wheels uses to our assets directories
		application.wheels.controllerPath = "#loc.assetsPath#/controllers";
		//  clear defaults
		StructDelete(application.wheels.functions, "datePicker");
		StructDelete(application.wheels.functions, "datePickerTag");
		//  we're always going to need a controller for our test so we'll just create one
		params = {controller="foo", action="bar"};
		foo = controller("Foo", params);
		dateString = DateFormat(Now(), "mm/dd/yyyy");
		dateMask = "dd/mm/yy";
		dayArray = "['Sundy', 'Mondy', 'Tuesdy', 'Wednesdy', 'Thursdy', 'Fridy', 'Satdy']";
		inputString = '<input id="foo" name="foo" type="text" value="" />';
	}

	function test_datePickerTag_markup_using_defaults() {
		actual = foo.datePickerTag(name="foo", value=dateString);
		expected = '<input id="foo" name="foo" type="text" value="#dateString#" />';
		assert("actual eq expected");
	}

	function test_datePickerTag_renders_inline_script_tag() {
		actual = foo.datePickerTag(name="foo", value=dateString, head=false);
		expected = "<script>$(window).load(function() {$('##foo').datepicker()});</script>" & '<input id="foo" name="foo" type="text" value="#dateString#" />';
		assert("actual eq expected");
	}

	function test_datePickerTag_with_id_argument() {
		actual = foo.datePickerTag(name="foo", value=dateString, id="foo-bar");
		expected = '<input id="foo-bar" name="foo" type="text" value="#dateString#" />';
		assert("actual eq expected");
	}

	function test_datePickerTag_with_empty_value() {
		actual = foo.datePickerTag(name="foo", value="");
		expected = '<input id="foo" name="foo" type="text" value="" />';
		assert("actual eq expected");
	}

	function test_datePickerTag_with_dateFormat() {
		dateString = DateFormat(Now(), "dd/mm/yyyy");
		actual = foo.datePickerTag(name="foo", value=Now(), dateFormat=dateMask);
		expected = '<input id="foo" name="foo" type="text" value="#dateString#" />';
		assert("actual eq expected");
	}

	function test_datePickerTag_with_jquery_boolean_option() {
		dateString = DateFormat(Now(), "dd/mm/yyyy");
		actual = foo.datePickerTag(name="foo", value="", head=false, disabled="false");
		expected = "<script>$(window).load(function() {$('##foo').datepicker({disabled:false})});</script>" & inputString;
		assert("actual eq expected");
	}

	function test_datePickerTag_with_jquery_array_option() {
		dateString = DateFormat(Now(), "dd/mm/yyyy");
		actual = foo.datePickerTag(name="foo", value="", head=false, dayNames=dayArray);
		expected = "<script>$(window).load(function() {$('##foo').datepicker({dayNames:#dayArray#})});</script>" & inputString;
		assert("actual eq expected");
	}

	function test_datePickerTag_with_jquery_integer_option() {
		dateString = DateFormat(Now(), "dd/mm/yyyy");
		actual = foo.datePickerTag(name="foo", value="", head=false, stepMonths=2);
		expected = "<script>$(window).load(function() {$('##foo').datepicker({stepMonths:2})});</script>" & inputString;
		assert("actual eq expected");
	}

	function test_datePickerTag_with_jquery_object_option() {
		dateString = DateFormat(Now(), "dd/mm/yyyy");
		actual = foo.datePickerTag(name="foo", value="", head=false, showOptions="{direction:'up'}");
		expected = "<script>$(window).load(function() {$('##foo').datepicker({showOptions:{direction:'up'}})});</script>" & inputString;
		assert("actual eq expected");
	}

	function test_datePickerTag_with_multiple_jquery_options() {
		dateString = DateFormat(Now(), "dd/mm/yyyy");
		f = foo.datePickerTag(name="foo", value="", head=false, disabled="false", dayNames=dayArray, stepMonths=2, showOptions="{direction:'up'}", onClose="doThis(1)");
		_f = "<script>$(window).load(function() {$('##foo').datepicker({disabled:false, dayNames:#dayArray#, showOptions:{direction:'up'}, stepMonths:2, onClose:doThis(1)})});</script>" & inputString;
		assert("actual eq expected");
	}

	function test_$datePickerMapDateMask_mappings() {
		assert("foo.$datePickerMapDateMask('m/d/y') == 'm/d/yy'");
		assert("foo.$datePickerMapDateMask('mm/dd/y') == 'mm/dd/yy'");
		assert("foo.$datePickerMapDateMask('mm/dd/yy') == 'mm/dd/yyyy'");
		assert("foo.$datePickerMapDateMask('m-d-y') == 'm-d-yy'");
		assert("foo.$datePickerMapDateMask('mm-dd-y') == 'mm-dd-yy'");
		assert("foo.$datePickerMapDateMask('mm-dd-yy') == 'mm-dd-yyyy'");
		assert("foo.$datePickerMapDateMask('d/m/y') == 'd/m/yy'");
		assert("foo.$datePickerMapDateMask('dd/mm/y') == 'dd/mm/yy'");
		assert("foo.$datePickerMapDateMask('dd/mm/yy') == 'dd/mm/yyyy'");
		assert("foo.$datePickerMapDateMask('d-m-y') == 'd-m-yy'");
		assert("foo.$datePickerMapDateMask('dd-mm-y') == 'dd-mm-yy'");
		assert("foo.$datePickerMapDateMask('dd-mm-yy') == 'dd-mm-yyyy'");
	}

	function teardown() {
		//  recopy the original environment back after each test
		application = loc.orgApp;
	}

}
