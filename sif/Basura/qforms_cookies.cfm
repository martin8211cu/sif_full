<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<HTML>
<HEAD>
	<TITLE>qForms Examples: Cookies</TITLE>
	<!--// load the documentation style sheet //-->
	<!--// load the qForm JavaScript API //-->
	<SCRIPT SRC="../js/qForms/qforms.js"></SCRIPT>
	<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// set the path to the qForms directory
	qFormAPI.setLibraryPath("../js/qForms/");
	// load the "Cookies" add-on library
	qFormAPI.include("cookies");
	//-->
	</SCRIPT>
</HEAD>

<BODY BGCOLOR="#ffffff">

<P><TABLE WIDTH="800" BORDER="0" CELLSPACING="0" CELLPADDING="0" ALIGN="Center">
<TR>
	<TD WIDTH="800" COLSPAN="3"></TD>
</TR>
<TR>
	<TD WIDTH="60"></TD>
	<TD ALIGN="Left" VALIGN="Top">
	<!--// [start] insert main content //-->

<P><B CLASS="Heading">Cookies</B><BR>
This example illustrates how to use the "Cookies" extension library. It shows off some of the
common methods, such as the saveFields() and loadFields() methods.</P>

<FORM ACTION="showdata.htm" METHOD="GET" NAME="frmExample">
<P>Name:<BR>
<INPUT TYPE="Text" NAME="Name" SIZE="40"></P>

<P>E-mail:<BR>
<INPUT TYPE="Text" NAME="Email" SIZE="40"></P>

<P>Company:<BR>
<INPUT TYPE="Text" NAME="Company" SIZE="40"></P>

<P>
<INPUT TYPE="Button" VALUE="Load Form" onClick="objForm.loadFields();">
<INPUT TYPE="Button" VALUE="Save Form" onClick="objForm.saveFields();">
<INPUT TYPE="Submit" VALUE="Submit">
<INPUT TYPE="Button" VALUE="Reset" onClick="objForm.reset();">
</FORM>


<SCRIPT LANGUAGE="JavaScript">
<!--//
// initialize the qForm object
objForm = new qForm("frmExample");

// load the saved values from the form
objForm.loadFields();

// automatically save the form's content to a cookie when the form is submitted
objForm.saveOnSubmit();
//-->
</SCRIPT>


	<!--// [ end ] insert main content //-->

	</TD>
	<TD WIDTH="60"></TD>
</TR>
<TR>
	<TD WIDTH="800" COLSPAN="3"></TD>
</TR>
</TABLE></P>

</BODY>
</HTML>
