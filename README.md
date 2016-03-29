DatePicker V1.0.3
=================

Use a jQuery UI datePicker widget in your CFWheels forms
--------------------------------------------------------

datePicker and datePickerTag functions accept the same arguments as CFWheels textField and textFieldTag functions respectively, but they also accept all options for the jQuery datePicker widget

**Following the road to DatePicker Glory**

1. Install the DatePicker plugin
2. Make sure you have setup jQuery AND jQuery UI in your app
3. Use the datePicker() and datePickerTag() form helpers

**Examples**
```
<!--- Use with objects --->
#datePicker(label="Birthday", objectName="user", property="birthday")#

<!--- Use without objects --->
#datePickerTag(label="Birthday", name="birthday", value=Now())#

<!--- Use with jQuery datePicker options --->
#datePicker(label="Birthday", objectName="user", property="birthday", dateFormat="dd/mm/yy", goToCurrent=true, dayNames='["Sundy", "Mundy", "Tuesdy", "Wednesdy", "Thursdy", "Fridy", "Satdy"]')#
```
