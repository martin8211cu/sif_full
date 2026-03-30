<!--- Copyright (c) 2002 SiteObjects, Inc. --->

<!---

  SourceSafe: $Header: /SiteObjects/Products/soEditor/lite/examples/index.cfm 3     10/08/02 11:19a Don $
  Date Created: 9/10/2002
  Author: Don Bellamy
  Project: soEditor 2.5
  Description: Examples

--->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
  <title>soEditor Lite 2.5 :: Examples</title>
  <link href="styles/styles.css" rel="stylesheet" type="text/css">
</head>

<body>

<div id="content">

<img src="images/logo.soeditor.lite.25.gif" alt="soEditor Lite 2.5" width="300" height="70" border="0">

<h3>Example Applications</h3>

<p>
These demonstrations provide simple real-world examples of using soEditor in your applications.
In order to provide a solid understanding of how to use soEditor, we have included the ability to view source code within each example.
</p>

<p>You can find additional examples and more information on our web site at <a href="http://www.siteobjects.com/">http://www.siteobjects.com/</a>.</p>

<p>
<table border="0" width="100%">
  <tr valign="top">
    <td width="10"><img src="images/arrow.gif" alt="*" width="10" height="15" border="0"></td>
    <td>
    <a href="example.one.cfm">Example one</a><br>
    This example displays the default configuration of soEditor in a stand-alone form. 
    </td>
  </tr>
</table>
</p>

<p>
<table border="0" width="100%">
  <tr valign="top">
    <td width="10"><img src="images/arrow.gif" alt="*" width="10" height="15" border="0"></td>
    <td>
    <a href="example.two.cfm">Example two</a><br>
    This example demonstrates how soEditor can be used within a form.
    Focus is set to the name field in the <span class="code">initialfocus</span> attribute. 
    Field validation is also enabled by setting the <span class="code">validateonsave</span> attribute to true and by using the <span class="code">validationmessage</span> attribute.
    </td>
  </tr>
</table>
</p>

<p>
<table border="0" width="100%">
  <tr valign="top">
    <td width="10"><img src="images/arrow.gif" alt="*" width="10" height="15" border="0"></td>
    <td>
    <a href="example.three.cfm">Example three</a><br>
    This example demonstrates how to use more than one instance of soEditor within a form.
    The <span class="code">basefont</span> attribute is set to Arial and the <span class="code">basefontsize</span> attribute is set to 2.
    The <span class="code">font</span> and <span class="code">htmledit</span> attributes are set to false in order to control all formatting with the base font and size.
    Focus is set to the title field in the <span class="code">initialfocus</span> attribute.
    </td>
  </tr>
</table>
</p>

<p>
<table border="0" width="100%">
  <tr valign="top">
    <td width="10"><img src="images/arrow.gif" alt="*" width="10" height="15" border="0"></td>
    <td>
    <a href="example.four.cfm">Example four</a><br>
    This example shows you how soEditor can be used to load, edit and save an entire html file.
    The <span class="code">cffile</span> tag is used to read the file and by setting the <span class="code">pageedit</span> attribute to true we are able to preserve the html, head and body elements.
    </td>
  </tr>
</table>
</p>

<br>

<p align="center" style="font-size:smaller;">
<img src="images/logo.so.jpg" width="28" height="33"><br>
Copyright &copy; 2002 <a href="http://www.siteobjects.com/" target="_blank">SiteObjects</a>, Inc.<br>
</p>
    
</div>

<br>

</body>
</html>