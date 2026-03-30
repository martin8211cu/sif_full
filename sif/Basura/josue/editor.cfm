<!---
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Untitled Document</title>
</head>

<body>
<script type="text/javascript" src="FCKeditor/fckeditor.js"></script>

<form name="form1" method="post">
<table width="100%">
<script type="text/javascript">
<!--
var oFCKeditor = new FCKeditor( 'FCKeditor1' ) ;
oFCKeditor.BasePath	= '/FCKeditor/' ;
oFCKeditor.InstanceName	= 'prueba' ;
oFCKeditor.Value = '' ;
oFCKeditor.Create() ;


//-->
</script>

<input type="submit" name="probar" value="probar" style="width:30px" onClick="javascript:f();">
</table>
</form>

<!---<cfdump var="#form#">--->

<script type="text/javascript" language="javascript1.2">
	function f(){
		var oTextarea = document.getElementsByName( oFCKeditor.InstanceName )[0] ;
		alert(oTextarea.type);
	}
</script>

</body>
</html>
--->

<html>
  <head>
  </head>
  <body>

<!---
<form name="form1" method="post">
	<table width="100%">
		<tr>
			<td>
				<script type="text/javascript" src="FCKeditor/fckeditor.js"></script>
				<script type="text/javascript">
				  window.onload = function()
				  {
					var oFCKeditor = new FCKeditor( 'MyTextarea' ) ;
					oFCKeditor.ToolbarSet = 'SIF';
					oFCKeditor.ReplaceTextarea() ;
				  }
				</script>
				<cfoutput><textarea id="MyTextarea" name="MyTextarea" onFocus="this.select();" onBlur="javascript:alert(this.vaule)"><cfif isdefined("form.MyTextarea") and len(trim(form.MyTextarea))>#form.MyTextarea#</cfif></textarea></cfoutput>
			</td>
		</tr>
	</table>
	<textarea id="x" name="x"></textarea>
	<input type="submit" name="probar" value="probar" onClick="javascript:f();">
</form>
--->

<form name="form1" method="post">
	<table width="100%">
		<tr>
			<td width="50%">
				<cf_sifeditorhtml name="arsenal" value="Vamos Arsenal!" toolbarset="SIF" >
			</td>
		</tr>

	</table>

	<input type="button" name="probar" value="probar" onClick="javascript:p();">
</form>

<script language="javascript1.2" type="text/javascript">
	function p(){
		//window.frames['agenda'].document.forms[vForm][oldName].name = newName;
		var iframe = window.frames['arsenal___Frame'].document.frames['eEditorArea'].document.arsenal;
		alert(iframe);
	}
</script>
  </body>



</html>

