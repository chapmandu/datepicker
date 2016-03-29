<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<!--- save the orginal environment --->
		<cfset loc.orgApp = Duplicate(application) />
		<!--- path to our plugins assets folder where we will store our components and files --->
		<cfset loc.assetsPath = "plugins/DatePicker/tests/assets" />
		<!--- repoint the lookup paths wheels uses to our assets directories --->
		<cfset application.wheels.controllerPath = "#loc.assetsPath#/controllers" />
		<!--- clear defaults --->
		<cfset StructDelete(application.wheels.functions, "datePicker")>
		<cfset StructDelete(application.wheels.functions, "datePickerTag")>
		<!--- we're always going to need a controller for our test so we'll just create one --->
		<cfset params = {controller="foo", action="bar"} />
		<cfset foo = controller("Foo", params) />
	</cffunction>
	
	<cffunction name="test_00_setup_and_teardown">
		<cfset assert("true")>
	</cffunction>
	
	<cffunction name="_test_01_datePickerTag_markup_using_default_jquery_options">
		<cfset dateString = DateFormat(Now(), "mm/dd/yyyy")>
		
		<cfset a = foo.datePickerTag(name="foo", value=dateString)>
		<cfset _a = '<input id="foo" name="foo" type="text" value="#dateString#" />'>
		
		<cfset b = foo.datePickerTag(name="foo", value=dateString, head=false)>
		<cfset _b = "<script>$(window).load(function() {$('##foo').datepicker()});</script>" & '<input id="foo" name="foo" type="text" value="#dateString#" />'>
		
		<cfset c = foo.datePickerTag(name="foo", value=dateString, id="foo-bar")>
		<cfset _c = '<input id="foo-bar" name="foo" type="text" value="#dateString#" />'>
		
		<cfset d = foo.datePickerTag(name="foo", value="")>
		<cfset _d = '<input id="foo" name="foo" type="text" value="" />'>
		
		<cfset assert("a eq _a")>
		<cfset assert("b eq _b")>
		<cfset assert("c eq _c")>
		<cfset assert("d eq _d")>
	</cffunction>
	
	<cffunction name="test_02_datePickerTag_markup_using_jquery_options">
		<cfset dateMask = "dd/mm/yy">
		<cfset dateString = DateFormat(Now(), "dd/mm/yyyy")>
		<cfset dayArray = "['Sundy', 'Mondy', 'Tuesdy', 'Wednesdy', 'Thursdy', 'Fridy', 'Satdy']">
		<cfset inputString = '<input id="foo" name="foo" type="text" value="" />'>
		
		<!--- dateFormat string --->
		<cfset a = foo.datePickerTag(name="foo", value=Now(), dateFormat=dateMask)>
		<cfset _a = '<input id="foo" name="foo" type="text" value="#dateString#" />'>

		<!--- boolean --->
		<cfset b = foo.datePickerTag(name="foo", value="", head=false, disabled="false")>
		<cfset _b = "<script>$(window).load(function() {$('##foo').datepicker({disabled:false})});</script>" & inputString>
		
		<!--- array --->
		<cfset c = foo.datePickerTag(name="foo", value="", head=false, dayNames=dayArray)>
		<cfset _c = "<script>$(window).load(function() {$('##foo').datepicker({dayNames:#dayArray#})});</script>" & inputString>
		
		<!--- integer --->
		<cfset d = foo.datePickerTag(name="foo", value="", head=false, stepMonths=2)>
		<cfset _d = "<script>$(window).load(function() {$('##foo').datepicker({stepMonths:2})});</script>" & inputString>
		
		<!--- object --->
		<cfset e = foo.datePickerTag(name="foo", value="", head=false, showOptions="{direction:'up'}")>
		<cfset _e = "<script>$(window).load(function() {$('##foo').datepicker({showOptions:{direction:'up'}})});</script>" & inputString>
		
		<!--- multiple --->
		<cfset f = foo.datePickerTag(name="foo", value="", head=false, disabled="false", dayNames=dayArray, stepMonths=2, showOptions="{direction:'up'}", onClose="doThis(1)")>
		<cfset _f = "<script>$(window).load(function() {$('##foo').datepicker({disabled:false,dayNames:#dayArray#,showOptions:{direction:'up'},stepMonths:2,onClose:doThis(1)})});</script>" & inputString>
		
		<cfset assert("a eq _a")>
		<cfset assert("b eq _b")>
		<cfset assert("c eq _c")>
		<cfset assert("d eq _d")>
		<cfset assert("e eq _e")>
		<cfset assert("f eq _f")>
	</cffunction>

	
	<cffunction name="test_03_$datePickerMapDateMask_mappings">
		<cfset assert("foo.$datePickerMapDateMask('m/d/y') eq 'm/d/yy'")>
		<cfset assert("foo.$datePickerMapDateMask('mm/dd/y') eq 'mm/dd/yy'")>
		<cfset assert("foo.$datePickerMapDateMask('mm/dd/yy') eq 'mm/dd/yyyy'")>
		<cfset assert("foo.$datePickerMapDateMask('m-d-y') eq 'm-d-yy'")>
		<cfset assert("foo.$datePickerMapDateMask('mm-dd-y') eq 'mm-dd-yy'")>
		<cfset assert("foo.$datePickerMapDateMask('mm-dd-yy') eq 'mm-dd-yyyy'")>
		<cfset assert("foo.$datePickerMapDateMask('d/m/y') eq 'd/m/yy'")>
		<cfset assert("foo.$datePickerMapDateMask('dd/mm/y') eq 'dd/mm/yy'")>
		<cfset assert("foo.$datePickerMapDateMask('dd/mm/yy') eq 'dd/mm/yyyy'")>
		<cfset assert("foo.$datePickerMapDateMask('d-m-y') eq 'd-m-yy'")>
		<cfset assert("foo.$datePickerMapDateMask('dd-mm-y') eq 'dd-mm-yy'")>
		<cfset assert("foo.$datePickerMapDateMask('dd-mm-yy') eq 'dd-mm-yyyy'")>
	</cffunction>
	
	<cffunction name="teardown">
		<!--- recopy the original environment back after each test --->
		<cfset application = loc.orgApp>
	</cffunction>
		
</cfcomponent>
