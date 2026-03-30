<!--- Copyright (c) 2002 SiteObjects, Inc. --->

<!---

  SourceSafe: $Header: /SiteObjects/Products/soEditor/lite/soeditor_lite.cfm 39    11/21/02 5:41p James $
  Date Created: 9/5/2002
  Author: James Alexander
  Project: soEditor Lite 2.5 
  Description: soEditor custom tag

--->

<cfsetting enablecfoutputonly="True">

<!--- Required attributes --->
<cfparam name="Attributes.Form" type="string">
<cfparam name="Attributes.Field" type="string">
<cfparam name="Attributes.ScriptPath" type="string">

<!--- Optional attributes --->
<cfparam name="Attributes.Width" type="string" default="100%">
<cfparam name="Attributes.Height" type="string" default="250px">
<cfparam name="Attributes.Cols" type="numeric" default="60">
<cfparam name="Attributes.Rows" type="numeric" default="10">
<cfparam name="Attributes.PageEdit" type="boolean" default="false">
<cfparam name="Attributes.SingleSpaced" type="boolean" default="false">
<cfparam name="Attributes.WordCount"  type="boolean" default="true">
<cfparam name="Attributes.BaseURL" default="http://#CGI.HTTP_Host#">
<cfparam name="Attributes.BaseFont" type="string" default="">
<cfparam name="Attributes.BaseFontSize" type="string" default="">
<cfparam name="Attributes.BaseFontColor" type="string" default="">
<cfparam name="Attributes.BaseBGColor" type="string" default="">
<cfparam name="Attributes.ValidateOnSave" type="boolean" default="false">
<cfparam name="Attributes.ValidationMessage" type="string" default="Content is required">
<cfparam name="Attributes.Html" type="string" default="">
<cfparam name="Attributes.ShowBorders" type="boolean" default="false">
<cfparam name="Attributes.InitialFocus" type="string" default="false">

<!--- Toolbar attributes --->
<!--- Standard toolbar --->
<cfparam name="Attributes.New" type="boolean" default="true">
<cfparam name="Attributes.Save" type="boolean" default="true">
<cfparam name="Attributes.Cut" type="boolean" default="true">
<cfparam name="Attributes.Copy" type="boolean" default="true">
<cfparam name="Attributes.Paste" type="boolean" default="true">
<cfparam name="Attributes.Delete" type="boolean" default="true">
<cfparam name="Attributes.Find" type="boolean" default="true">
<cfparam name="Attributes.Undo" type="boolean" default="true">
<cfparam name="Attributes.Redo" type="boolean" default="true">
<cfparam name="Attributes.HR" type="boolean" default="true">
<cfparam name="Attributes.Image" type="boolean" default="true">
<cfparam name="Attributes.Link" type="boolean" default="true">
<cfparam name="Attributes.Anchor" type="boolean" default="true">
<cfparam name="Attributes.UnLink" type="boolean" default="true">
<cfparam name="Attributes.SpellCheck" type="boolean" default="false">
<cfparam name="Attributes.Help" type="boolean" default="true">
<!--- Paragraph toolbar --->
<cfparam name="Attributes.Align" type="boolean" default="true">
<cfparam name="Attributes.List" type="boolean" default="true"> 
<cfparam name="Attributes.Unindent" type="boolean" default="true">
<cfparam name="Attributes.Indent" type="boolean" default="true">
<!--- Format toolbar --->
<cfparam name="Attributes.FontDialog" type="boolean" default="true">
<cfparam name="Attributes.Format" type="boolean" default="true">
<cfparam name="Attributes.FormatList" type="string" default="none,h1,h2,h3,h4,h5,h6,pre">
<cfparam name="Attributes.FormatListLabels" type="string" default="Normal,Heading 1,Heading 2,Heading 3,Heading 4,Heading 5,Heading 6,Formatted">
<cfparam name="Attributes.Font" type="boolean" default="true">
<cfparam name="Attributes.FontList" type="string" default="Arial,Tahoma,Courier New,Times New Roman,Verdana,Wingdings">
<cfparam name="Attributes.FontListLabels" type="string" default="">
<cfparam name="Attributes.Size" type="boolean" default="true">
<cfparam name="Attributes.SizeList" type="string" default="1,2,3,4,5,6,7">
<cfparam name="Attributes.SizeListLabels" type="string" default="">
<cfparam name="Attributes.Bold" type="boolean" default="true">
<cfparam name="Attributes.Italic" type="boolean" default="true">
<cfparam name="Attributes.Underline" type="boolean" default="true">
<cfparam name="Attributes.SuperScript" type="boolean" default="true">
<cfparam name="Attributes.SubScript" type="boolean" default="true">
<cfparam name="Attributes.FgColor" type="boolean" default="true">
<cfparam name="Attributes.BgColor" type="boolean" default="true">
<!--- Tables toolbar --->
<cfparam name="Attributes.Tables" type="boolean" default="true">  
<cfparam name="Attributes.InsertCell" type="boolean" default="true">  
<cfparam name="Attributes.DeleteCell" type="boolean" default="true">  
<cfparam name="Attributes.InsertRow" type="boolean" default="true">  
<cfparam name="Attributes.DeleteRow" type="boolean" default="true">  
<cfparam name="Attributes.InsertColumn" type="boolean" default="true">  
<cfparam name="Attributes.DeleteColumn" type="boolean" default="true">  
<cfparam name="Attributes.SplitCell" type="boolean" default="true">
<cfparam name="Attributes.MergeCell" type="boolean" default="true"> 
<cfparam name="Attributes.CellProp" type="boolean" default="true">
<!--- View toolbar --->
<cfparam name="Attributes.HTMLEdit" type="boolean" default="true">  
<cfparam name="Attributes.Borders" type="boolean" default="true">
<cfparam name="Attributes.Details" type="boolean" default="true">   

<cfparam name="Caller.EditorCount" type="numeric" default="0">

<!--- browser check --->
<cfif REFindNoCase("MSIE [5|6].*win",CGI.HTTP_USER_AGENT)>
<!--- Used only in encrypted lite version, before encrypting make sure this line is changed !!!!!
  <cfif REFindNoCase("MSIE [5|6].*win",CGI.HTTP_USER_AGENT) AND NOT Val(Caller.EditorCount)> --->

<cfif NOT Val(Caller.EditorCount)>

  <cfhtmlhead text="<?xml:namespace prefix=""so"" />
  <script language=""javascript"" src=""#Attributes.ScriptPath#spch.js"" defer=""true""></script>
  <link rel=""stylesheet"" type=""text/css"" href=""#Attributes.ScriptPath#sotoolbar.css""></link>
  <style>
  so\:editor {behavior: url(#Attributes.ScriptPath#soeditor.htc);}
  so\:toolbar {behavior: url(#Attributes.ScriptPath#sotoolbar.htc);}    
  so\:toolbar .sobutton {behavior: url(#Attributes.ScriptPath#sobutton.htc);}
  so\:toolbar .soswitch {behavior: url(#Attributes.ScriptPath#soswitch.htc);}
  </style>
  <script language=""javascript"">
  function openAbout() {
    parent.showModalDialog(""#Attributes.ScriptPath#about.htm"",null,""dialogWidth:345px; dialogHeight:245px;help:0;status:no;"");
  }
  </script>">

</cfif>

<!--- Help window --->
<cfif Attributes.Help>
<cfhtmlhead text="
<script language=""javascript"">
  function openHelp#Attributes.Field#() {
    parent.showModalDialog(""#Attributes.ScriptPath#help.cfm?new=#Attributes.New#&save=#Attributes.Save#&cut=#Attributes.Cut#&copy=#Attributes.Copy#&paste=#Attributes.Paste#&delete=#Attributes.Delete#&find=#Attributes.Find#&undo=#Attributes.Undo#&redo=#Attributes.Redo#&hr=#Attributes.HR#&image=#Attributes.Image#&link=#Attributes.Link#&anchor=#Attributes.Anchor#&unlink=#Attributes.Unlink#&spellcheck=#Attributes.SpellCheck#&help=#Attributes.Help#&align=#Attributes.Align#&list=#Attributes.List#&unindent=#Attributes.Unindent#&indent=#Attributes.Indent#&fontdialog=#Attributes.FontDialog#&format=#Attributes.Format#&font=#Attributes.Font#&size=#Attributes.Size#&bold=#Attributes.Bold#&italic=#Attributes.Italic#&underline=#Attributes.Underline#&superscript=#Attributes.SuperScript#&subscript=#Attributes.SubScript#&fgcolor=#Attributes.FgColor#&bgcolor=#Attributes.BgColor#&tables=#Attributes.Tables#&insertcell=#Attributes.InsertCell#&deletecell=#Attributes.DeleteCell#&insertrow=#Attributes.InsertRow#&deleterow=#Attributes.DeleteRow#&insertcolumn=#Attributes.InsertColumn#&deletecolumn=#Attributes.DeleteColumn#&splitcell=#Attributes.SplitCell#&mergecell=#Attributes.MergeCell#&cellprop=#Attributes.CellProp#&htmledit=#Attributes.HTMLEdit#&borders=#Attributes.Borders#&details=#Attributes.Details#"",null,""dialogWidth:250px; dialogHeight:300px;help:0;status:no;"");  
  }
</script>">
</cfif>

<cfset Caller.EditorCount = Caller.EditorCount + 1>

<cfif Attributes.ShowBorders>
<cfhtmlhead text="<script for=""window"" event=""onload"">soEditor.toggleBorders();btnBorders.isPressed = true;</script>">
</cfif>

<cfoutput>
<input type="hidden" name="#Attributes.Field#" value="#HTMLEditFormat(Attributes.HTML)#">
<!--- table layout of soEditor and its tool bars --->
<table id="#Attributes.Field#Table" cellspacing="0" style="width:#Attributes.Width#;height:#Attributes.Height#;background:##d4d0c8;border:1 outset ##d4d0c8;">
<tr>
  <td colspan="2">
  
  <!--- Standard toolbar --->
  <cfif Attributes.New OR Attributes.Save OR Attributes.Cut OR Attributes.Copy OR Attributes.Paste OR Attributes.Delete OR Attributes.Find OR Attributes.Undo OR Attributes.Redo OR Attributes.HR OR Attributes.Image OR Attributes.Link OR Attributes.Spellcheck OR Attributes.Help>
  <so:toolbar id="sotb_standard" style="width:1px;">
  <span id="soToolBar">
  <table cellspacing="0"><tr>
    <td><img align="absmiddle" src="#Attributes.ScriptPath#icons/toolbar.gif" width="5" height="20" border="0" alt=""/></td>
    <cfif Attributes.New><td nowrap="true" class="sobutton" title="new" id="btnNew#Attributes.Field#" action="soEditor#Attributes.Field#.newDocument();"><img align="absmiddle" src="#Attributes.ScriptPath#icons/newdoc.gif" width="16" height="15"></td></cfif>
    <cfif Attributes.Save><td nowrap="true" class="sobutton" title="save" id="btnSave#Attributes.Field#" action="soEditor#Attributes.Field#.saveDoc();"><img align="absmiddle" src="#Attributes.ScriptPath#icons/save.gif" width="16" height="15"/></td></cfif>
    <cfif Attributes.New OR Attributes.Save><td><img align="absmiddle" src="#Attributes.ScriptPath#icons/separator.gif" width="3" height="20" border="0" alt=""/></td></cfif>
    <cfif Attributes.Cut><td nowrap="true" class="sobutton" title="cut" id="btnCut#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5003);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/cut.gif" width="16" height="15"/></td></cfif>
    <cfif Attributes.Copy><td nowrap="true" class="sobutton" title="copy" id="btnCopy#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5002);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/copy.gif" width="16" height="15"/></td></cfif>    
    <cfif Attributes.Paste><td nowrap="true" class="sobutton" title="paste" id="btnPaste#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5032);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/paste.gif" width="16" height="15"/></td></cfif>
    <cfif Attributes.Delete><td nowrap="true" class="sobutton" title="delete" id="btnDelete#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5004);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/delete.gif" width="16" height="15"/></td></cfif>
    <cfif Attributes.Find><td nowrap="true" class="sobutton" title="find" id="btnFind#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5008,1);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/find.gif" width="16" height="15"/></td></cfif>
    <cfif Attributes.Cut OR Attributes.Copy OR Attributes.Paste OR Attributes.Delete OR Attributes.Find><td><img align="absmiddle" src="#Attributes.ScriptPath#icons/separator.gif" width="3" height="20" border="0" alt=""/></td></cfif>
    <cfif Attributes.Undo><td nowrap="true" class="sobutton" title="undo" id="btnUndo#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5049);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/undo.gif" width="16" height="15"/></td></cfif>
    <cfif Attributes.Redo><td nowrap="true" class="sobutton" title="redo" id="btnRedo#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5033);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/redo.gif" width="16" height="15"/></td></cfif>
    <cfif Attributes.Undo OR Attributes.Redo><td><img align="absmiddle" src="#Attributes.ScriptPath#icons/separator.gif" width="3" height="20" border="0" alt=""/></td></cfif>
    <cfif Attributes.HR><td nowrap="true" class="sobutton" title="horizontal rule" id="btnHR#Attributes.Field#" action="soEditor#Attributes.Field#.insertText('<hr/>','',true,true);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/hr.gif" width="16" height="15"/></td></cfif>
    <cfif Attributes.Image><td nowrap="true" class="sobutton" title="image" id="btnImage#Attributes.Field#" action="soEditor#Attributes.Field#.image();"><img align="absmiddle" src="#Attributes.ScriptPath#icons/image.gif" width="16" height="15"/></td></cfif>
    <cfif Attributes.Link><td nowrap="true" class="sobutton" title="hyperlink" id="btnLink#Attributes.Field#" action="soEditor#Attributes.Field#.insertLink(false);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/link.gif" width="16" height="15"/></td></cfif>
    <cfif Attributes.Anchor><td nowrap="true" class="sobutton" title="anchor" id="btnAnchor#Attributes.Field#" action="soEditor#Attributes.Field#.insertLink(true);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/anchor.gif" width="18" height="18" /></td></cfif>
    <cfif Attributes.UnLink><td nowrap="true" class="sobutton" title="remove hyperlink" id="btnUnLink#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5050,0,null);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/unlink.gif" width="16" height="15"/></td></cfif>
    <cfif Attributes.HR OR Attributes.Image OR Attributes.Link OR Attributes.Unlink><td><img align="absmiddle" src="#Attributes.ScriptPath#icons/separator.gif" width="3" height="20" border="0" alt=""/></td></cfif>
    <cfif Attributes.SpellCheck><td nowrap="true" class="sobutton" title="check spelling" id="btnSpellChk#Attributes.Field#" action="soEditor#Attributes.Field#.checkSpelling();"><img align="absmiddle" src="#Attributes.ScriptPath#icons/spellcheck.gif" width="16" height="15" alt="check spelling"/></td></cfif>
    <cfif Attributes.Help><td nowrap="true" class="sobutton" title="open help" id="btnHelp#Attributes.Field#" action="openHelp#Attributes.Field#();"><img align="absmiddle" src="#Attributes.ScriptPath#icons/help.gif" width="16" height="15"/></td></cfif>
    <td width="2"></td>
  </tr></table>
  </span>
  </so:toolbar>
  </cfif>

  <!--- Paragraph toolbar --->
  <cfif Attributes.Align OR Attributes.List OR Attributes.Unindent OR Attributes.Indent>
  <so:toolbar id="sotb_paragraph" style="width:1px;">
  <span id="soToolBar">
  <table cellspacing="0"><tr>
    <td><img align="absmiddle" src="#Attributes.ScriptPath#icons/toolbar.gif" width="5" height="20" border="0" alt=""/></td>
    <cfif Attributes.Align>
      <td nowrap="true" class="soswitch" title="align left" id="btnAlign#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5025);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/left.gif" width="16" height="15"/></td>
      <td nowrap="true" class="soswitch" title="align center" id="btnAlign#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5024);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/center.gif" width="16" height="15"/></td>
      <td nowrap="true" class="soswitch" title="align right" id="btnAlign#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5026);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/right.gif" width="16" height="15"/></td>
    </cfif>
    <cfif Attributes.Align><td><img align="absmiddle" src="#Attributes.ScriptPath#icons/separator.gif" width="3" height="20" border="0" alt=""/></td></cfif>
    <cfif Attributes.List>
      <td nowrap="true" class="soswitch" title="numbered list" id="btnList#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5030);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/numlist.gif" width="16" height="15"/></td>    
      <td nowrap="true" class="soswitch" title="bulleted list" id="btnList#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5051);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/bullist.gif" width="16" height="15"/></td>    
    </cfif>
    <cfif Attributes.Unindent><td nowrap="true" class="sobutton" title="undent" id="btnUnIndent#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5031);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/deindent.gif" width="16" height="15"/></td></cfif>    
    <cfif Attributes.Indent><td nowrap="true" class="sobutton" title="indent" id="btnIndent#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5018);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/indent.gif" width="16" height="15"/></td></cfif>
    <td width="2"></td>
  </tr></table>
  </span>
  </so:toolbar>
  </cfif>
  
  <!--- Format toolbar --->
  <cfif Attributes.FontDialog OR (Attributes.Format AND ListLen(Attributes.FormatList)) OR (Attributes.Font AND ListLen(Attributes.FontList)) OR (Attributes.Size AND ListLen(Attributes.SizeList)) OR Attributes.Bold OR Attributes.Italic OR Attributes.Underline OR Attributes.SuperScript OR Attributes.SubScript OR Attributes.FgColor OR Attributes.BgColor>
  <so:toolbar id="sotb_format" style="width:1px;">
  <span id="soToolBar">
  <table cellspacing="0"><tr>
    <td><img align="absmiddle" src="#Attributes.ScriptPath#icons/toolbar.gif" width="5" height="20" border="0" alt=""/></td>
    <cfif Attributes.FontDialog><td nowrap="true" class="sobutton" title="font properties" id="btnFontCtrl#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5009);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/font.gif" width="16" height="15"/></td></cfif>
    <cfif Attributes.Format AND ListLen(Attributes.FormatList)><td title="format"><select id="btnFormat#Attributes.Field#" onchange="soEditor#Attributes.Field#.blockFormat(this.options[this.selectedIndex].value);"><cfloop from="1" to="#ListLen(Attributes.FormatList)#" index="idx"><option value="#ListGetAt(Attributes.FormatList, idx)#"><cfif ListLen(Attributes.FormatListLabels) GTE idx>#ListGetAt(Attributes.FormatListLabels, idx)#<cfelse>#ListGetAt(Attributes.FormatList, idx)#</cfif></option></cfloop></select></cfif>
    <cfif Attributes.Font AND ListLen(Attributes.FontList)><td title="format"><select id="btnFont#Attributes.Field#" onchange="soEditor#Attributes.Field#.execCmd(5044,0,this.options[this.selectedIndex].value);"><cfloop from="1" to="#ListLen(Attributes.FontList)#" index="idx"><option value="#ListGetAt(Attributes.FontList, idx)#"><cfif ListLen(Attributes.FontListLabels) GTE idx>#ListGetAt(Attributes.FontListLabels, idx)#<cfelse>#ListGetAt(Attributes.FontList, idx)#</cfif></option></cfloop></select></cfif>
    <cfif Attributes.Size AND ListLen(Attributes.SizeList)><td title="format"><select id="btnSize#Attributes.Field#" onchange="soEditor#Attributes.Field#.execCmd(5045,0,this.options[this.selectedIndex].value);"><cfloop from="1" to="#ListLen(Attributes.SizeList)#" index="idx"><option value="#ListGetAt(Attributes.SizeList, idx)#"><cfif ListLen(Attributes.SizeListLabels) GTE idx>#ListGetAt(Attributes.SizeListLabels, idx)#<cfelse>#ListGetAt(Attributes.SizeList, idx)#</cfif></option></cfloop></select></cfif>
    <cfif Attributes.FontDialog OR (Attributes.Format AND ListLen(Attributes.FormatList)) OR (Attributes.Font AND ListLen(Attributes.FontList)) OR (Attributes.Size AND ListLen(Attributes.SizeList))><td><img align="absmiddle" src="#Attributes.ScriptPath#icons/separator.gif" width="3" height="20" border="0" alt=""/></td></cfif>
    <cfif Attributes.Bold><td nowrap="true" class="soswitch" title="bold" id="btnBold#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5000);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/bold.gif" width="16" height="15"/></td></cfif>      
    <cfif Attributes.Italic><td nowrap="true" class="soswitch" title="italic" id="btnItalic#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5023);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/italic.gif" width="16" height="15"/></td></cfif>      
    <cfif Attributes.Underline><td nowrap="true" class="soswitch" title="underline" id="btnUnder#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5048);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/under.gif" width="16" height="15"/></td></cfif>          
    <cfif Attributes.Bold OR Attributes.Italic OR Attributes.Underline><td><img align="absmiddle" src="#Attributes.ScriptPath#icons/separator.gif" width="3" height="20" border="0" alt=""/></td></cfif>
    <cfif Attributes.SuperScript><td nowrap="true" class="sobutton" title="superscript" id="btnSuper#Attributes.Field#" action="soEditor#Attributes.Field#.insertText('<sup>','</sup>',true,false);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/superscript.gif" width="16" height="15" unselectable="on"/></td></cfif>      
    <cfif Attributes.SubScript><td nowrap="true" class="sobutton" title="subscript" id="btnSub#Attributes.Field#" action="soEditor#Attributes.Field#.insertText('<sub>','</sub>',true,false);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/subscript.gif" width="16" height="15"/></td></cfif>
    <cfif Attributes.SuperScript OR Attributes.SubScript><td><img align="absmiddle" src="#Attributes.ScriptPath#icons/separator.gif" width="3" height="20" border="0" alt=""/></td></cfif>
    <cfif Attributes.FgColor><td nowrap="true" class="sobutton" title="foreground color" id="btnFgColor#Attributes.Field#" action="soEditor#Attributes.Field#.colorPicker(5046);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/fgcolor.gif" width="16" height="15"/></td></cfif>    
    <cfif Attributes.BgColor><td nowrap="true" class="sobutton" title="background color" id="btnBgColor#Attributes.Field#" action="soEditor#Attributes.Field#.colorPicker(5042);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/bgcolor.gif" width="16" height="15"/></td></cfif>
    <td width="2"></td>
  </tr></table>
  </span>
  </so:toolbar>
  </cfif>

  <!--- Tables toolbar --->
  <cfif Attributes.Tables>
  <so:toolbar id="sotb_table" style="width:1px;">
  <span id="soToolBar">
  <table cellspacing="0"><tr>
    <td><img align="absmiddle" src="#Attributes.ScriptPath#icons/toolbar.gif" width="5" height="20" border="0" alt=""/></td>  
    <td nowrap="true" class="sobutton" title="insert table" id="btnTable#Attributes.Field#" action="soEditor#Attributes.Field#.insertTable();"><img align="absmiddle" src="#Attributes.ScriptPath#icons/instable.gif" width="16" height="15"/></td>    
    <cfif Attributes.InsertCell><td nowrap="true" class="sobutton" title="insert cell" id="btnInsCell#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5019);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/inscell.gif" width="16" height="15"/></td></cfif>
    <cfif Attributes.DeleteCell><td nowrap="true" class="sobutton" title="delete cell" id="btnDelCell#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5005);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/delcell.gif" width="16" height="15"/></td></cfif>
    <cfif Attributes.InsertRow><td nowrap="true" class="sobutton" title="insert row" id="btnInsRow#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5021);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/insrow.gif" width="16" height="15"/></td></cfif>      
    <cfif Attributes.DeleteRow><td nowrap="true" class="sobutton" title="delete row" id="btnDelRow#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5007);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/delrow.gif" width="16" height="15"/></td></cfif>      
    <cfif Attributes.InsertColumn><td nowrap="true" class="sobutton" title="insert column" id="btnInsColumn#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5020);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/inscol.gif" width="16" height="15"/></td></cfif>      
    <cfif Attributes.DeleteColumn><td nowrap="true" class="sobutton" title="delete column" id="btnDelColumn#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5006);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/delcol.gif" width="16" height="15"/></td></cfif>      
    <cfif Attributes.SplitCell><td nowrap="true" class="sobutton" title="split cell" id="btnSpltCell#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5047);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/splitcell.gif" width="16" height="15"/></td></cfif>      
    <cfif Attributes.MergeCell><td nowrap="true" class="sobutton" title="merge cells" id="btnMrgCell#Attributes.Field#" action="soEditor#Attributes.Field#.execCmd(5029);"><img align="absmiddle" src="#Attributes.ScriptPath#icons/mrgcell.gif" width="16" height="15"/></td></cfif>      
    <cfif Attributes.CellProp><td nowrap="true" class="sobutton" title="cell properties" id="btnTDProp#Attributes.Field#" action="soEditor#Attributes.Field#.tdProperties();"><img align="absmiddle" src="#Attributes.ScriptPath#icons/tdprop.gif" width="16" height="15"/></td></cfif>
  </tr></table>
  </span>
  </so:toolbar>
  </cfif>
  
  </td>
</tr>
<tr>
  <td colspan="2" height="#Attributes.Height#">
    <so:editor id="soEditor#Attributes.Field#" scriptpath="#Attributes.ScriptPath#" pageedit="#LCase(Attributes.PageEdit)#"  basefont="#Attributes.BaseFont#" basefontsize="#Attributes.BaseFontSize#"  basefontcolor="#Attributes.BaseFontColor#" basebgcolor="#Attributes.BaseBGColor#" field="#Attributes.field#" form="#Attributes.form#" baseURL="#Attributes.baseURL#" height="100%" width="100%" singlespaced="#LCase(Attributes.SingleSpaced)#" wordcount="#LCase(Attributes.WordCount)#"  validateonsave="#Attributes.ValidateOnSave#" validationmessage="#Attributes.ValidationMessage#" initialfocus="#Attributes.InitialFocus#" platform="CF" />
  </td>
</tr>
<tr>
  <td colspan="2">
    <table cellspacing="0" width="100%">
    <tr><td width="50">
    
    <!--- View toolbar --->
    <cfif Attributes.HTMLEdit OR Attributes.Borders OR Attributes.Details>
    <so:toolbar id="sotb_view" style="width:1px;">
    <span id="soToolBar">
    <table cellspacing="0"><tr>    
      <td><img align="absmiddle" src="#Attributes.ScriptPath#icons/toolbar.gif" width="5" height="20" border="0" alt=""/></td>  
      <cfif Attributes.HTMLEdit><td nowrap="true" class="soswitch" title="toggle edit mode" id="btnMode#Attributes.Field#" action="soEditor#Attributes.Field#.SourceEdit = !soEditor#Attributes.Field#.SourceEdit;"><img align="absmiddle" src="#Attributes.ScriptPath#icons/viewsource.gif" width="16" height="15"/></td></cfif>
      <cfif Attributes.Borders><td nowrap="true" class="soswitch" title="toggle borders" id="btnBorders#Attributes.Field#" action="soEditor#Attributes.Field#.toggleBorders();"><img align="absmiddle" src="#Attributes.ScriptPath#icons/borders.gif" width="15" height="15"/></td></cfif>
      <cfif Attributes.Details><td nowrap="true" class="soswitch" title="toggle details" id="btnDetails#Attributes.Field#" action="soEditor#Attributes.Field#.toggleDetails();"><img align="absmiddle" src="#Attributes.ScriptPath#icons/details.gif" width="16" height="15"/></td></cfif>
    </tr></table>
    </span>
    </so:toolbar>
    </cfif>
    
    </td>
    <td onclick="openAbout();" style="text-align:center;font:8pt Tahoma;cursor:hand;background-color:##D4D0C8;color:##000000;"><img src="#Attributes.ScriptPath#icons/soeditor_icon.gif" height="20" width="17" title="about" align="absmiddle">&nbsp;soEditor Lite 2.5</td>    
    <td style="text-align:right;width:100px;border-width: 1px;border-style: solid;border-color: threeddarkshadow white white threeddarkshadow;font:8pt Tahoma;background-color:##D4D0C8;color:##000000;">
      <nobr><span id="totalwords#Attributes.Field#" style="width:95px;text-align:left;">loading...</span></nobr>
    </td>
    </tr>
    </table>
  </td>
</tr>
</table>
</cfoutput>

<cfelse>

<!--- Display textarea for non supporting browsers --->
<cfoutput>
<cfif Attributes.Save><input type="submit" name="Save" value="Save"><br></cfif>
<textarea name="#Attributes.Field#" cols="#Attributes.Cols#" rows="#Attributes.Rows#" wrap="virtual">#Attributes.HTML#</textarea>
</cfoutput>

</cfif>

<cfsetting enablecfoutputonly="False">
