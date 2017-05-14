<cfoutput>
<h1>DatePicker V2.0.1</h1>
<h3>Use a jQuery UI datePicker widget in your CFWheels forms</h3>

<p>datePicker and datePickerTag functions accept the same arguments as CFWheels textField and textFieldTag functions respectively, but they also accept all options for the <a href="http://jqueryui.com/demos/datepicker/" target="_blank">jQuery datePicker widget</a></p>

<h2>Following the road to DatePicker Glory</h2>
<ul>
	<li>Install the DatePicker plugin</li>
	<li>Make sure you have setup jQuery AND jQuery UI in your app (Consider the <a href="http://cfwheels.org/plugins/listing/73" target="_blank">jQuack plugin</a>)</li>
	<li>Use the <code>datePicker()</code> and <code>datePickerTag()</code> form helpers</li>
</ul>

<h2>Examples</h2>
<pre>
&lt;!--- Use with objects --->
##datePicker(label="Birthday", objectName="user", property="birthday")##

&lt;!--- Use without objects --->
##datePickerTag(label="Birthday", name="birthday", value=Now())##
</pre>

<h2>Notes</h2>
<p>All jQuery specific arguments (jQuery datePicker options) are case-sensitive</p>

<h2>Disclaimer</h2>
<p>Use this plugin at your own risk. All care taken, but no responsibility.<br /> This plugin may:
	<ul>
		<li>Not accept some unusual <code>dateFormat</code> values</li>
		<li>Not work as described</li>
		<li>Rot your teeth</li>
	</ul>
</p>
</cfoutput>
