<html>
<head>
<title>tabs sample</title>
<meta http-equiv="Content-Type" content="text/html;">
<style type="text/css">
.tab_sel {
cursor:pointer;font-family:Verdana,Arial,Helvetica,sans-serif;font-size:11px;background-image:url(/cfmx/sif/imagenes/tabs/sel_m.png)
}
.tab_nor {
cursor:pointer;font-family:Verdana,Arial,Helvetica,sans-serif;font-size:11px;background-image:url(/cfmx/sif/imagenes/tabs/nor_m.png)
}
.tab_contents {
	border-bottom:1px solid #CCCCCC;
	border-left:1px solid #CCCCCC;
	border-right:1px solid #CCCCCC;
	background-color:#f3f4f8;
}
</style>
<script type="text/javascript">
<!--
var tab_current = 1
function tab_set_style(n,style_prefix,style_display){
	var elem_l = document.getElementById('tab' + n + 'l');
	var elem_m = document.getElementById('tab' + n + 'm');
	var elem_r = document.getElementById('tab' + n + 'r');
	var elem_c = document.getElementById('tab' + n + 'c');
	elem_l.src='/cfmx/sif/imagenes/tabs/'+style_prefix+'_l.png';
	elem_m.className='tab_'+style_prefix;
	elem_r.src='/cfmx/sif/imagenes/tabs/'+style_prefix+'_r.png';
	elem_c.style.display = style_display;
}
function tab_set_current (n){
	if (tab_current == n) return;
	tab_set_style(tab_current, 'nor', 'none');
	tab_current = n;
	tab_set_style(tab_current, 'sel', 'block');
}
//-->
</script>
</head>
<body bgcolor="#ffffff">
<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan="27"><img name="sample_r1_c1" src="/cfmx/sif/imagenes/tabs/sample_r1_c1.jpg" width="1050" height="371" border="0" alt=""></td>
    <td><img src="/cfmx/sif/imagenes/tabs/spacer.gif" width="1" height="371" border="0" alt=""></td>
  </tr>
</table>
  <table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td><img name="/cfmx/sif/imagenes/tabs/sample_r2_c1" src="/cfmx/sif/imagenes/tabs/sample_r2_c1.gif" width="22" height="21" border="0" alt=""></td>
    <td><img src="/cfmx/sif/imagenes/tabs/div.png" width="8" height="21" border="0" alt=""></td>
    <!--- selected --->
    <td><img id="tab1l" src="/cfmx/sif/imagenes/tabs/sel_l.png" width="7" height="21" border="0" alt=""></td>
    <td id="tab1m" class="tab_sel" onclick="tab_set_current(1)"><u>I</u>tem</td>
    <td><img id="tab1r" src="/cfmx/sif/imagenes/tabs/sel_r.png" width="7" height="21" border="0" alt=""></td>
    <td><img src="/cfmx/sif/imagenes/tabs/div.png" width="1" height="21" border="0" alt=""></td>
    <!--- normal --->
    <td><img id="tab2l" src="/cfmx/sif/imagenes/tabs/nor_l.png" width="7" height="21" border="0" alt=""></td>
    <td id="tab2m" class="tab_nor" onclick="tab_set_current(2)"><u>A</u>ddress</td>
    <td><img id="tab2r" src="/cfmx/sif/imagenes/tabs/nor_r.png" width="7" height="21" border="0" alt=""></td>
    <td><img src="div.png" width="1" height="21" border="0" alt=""></td>
    <td><img id="tab3l" src="/cfmx/sif/imagenes/tabs/nor_l.png" width="7" height="21" border="0" alt=""></td>
    <td id="tab3m" class="tab_nor" onclick="tab_set_current(3)"><u>S</u>hipping</td>
    <td><img id="tab3r" src="/cfmx/sif/imagenes/tabs/nor_r.png" width="7" height="21" border="0" alt=""></td>
    <td><img src="div.png" width="1" height="21" border="0" alt=""></td>
    <td><img id="tab4l" src="/cfmx/sif/imagenes/tabs/nor_l.png" width="7" height="21" border="0" alt=""></td>
    <td id="tab4m" class="tab_nor" onclick="tab_set_current(4)"><u>P</u>ayment</td>
    <td><img id="tab4r" src="/cfmx/sif/imagenes/tabs/nor_r.png" width="7" height="21" border="0" alt=""></td>
    <td><img name="sample_r2_c6" src="div.png" width="1" height="21" border="0" alt=""></td>
    <td><img id="tab5l"  src="/cfmx/sif/imagenes/tabs/nor_l.png" width="7" height="21" border="0" alt=""></td>
    <td id="tab5m" class="tab_nor" onclick="tab_set_current(5)"><u>O</u>uput&nbsp;Options</td>
    <td><img id="tab5r" src="/cfmx/sif/imagenes/tabs/nor_r.png" width="7" height="21" border="0" alt=""></td>
    <td><img src="div.png" width="1" height="21" border="0" alt=""></td>
    <td><img id="tab6l" src="/cfmx/sif/imagenes/tabs/nor_l.png" width="7" height="21" border="0" alt=""></td>
    <td id="tab6m" class="tab_nor" onclick="tab_set_current(6)"><u>C</u>ustom</td>
    <td><img id="tab6r" src="/cfmx/sif/imagenes/tabs/nor_r.png" width="7" height="21" border="0" alt=""></td>
    <td><img src="/cfmx/sif/imagenes/tabs/div.png" width="1" height="21" border="0" alt=""></td>
    <td><img src="/cfmx/sif/imagenes/tabs/div.png" width="600" height="21" border="0" alt=""></td>
  </tr>
  </table>
  <table border="0" cellpadding="0" cellspacing="0" width="1005">
  <tr>
      <td width="22"><img name="sample_r2_c1" src="/cfmx/sif/imagenes/tabs/sample_r2_c1.gif" width="22" height="21" border="0" alt=""></td>
		<td width="983" class="tab_contents">
		<cfloop from="1" to="6" index="i">
		<cfoutput>
		<div id="tab#i#c" style="font-family:Verdana, Arial, Helvetica, sans-serif;font-size:11px;<cfif i neq 1>display:none;</cfif>">
		
		CONTENIDO #i# </div>
		</cfoutput>
		</cfloop>
		  <img name="sample_r3_c1" src="/cfmx/sif/imagenes/tabs/sample_r3_c1.jpg" width="985" height="207" border="0" alt=""></td></tr></table>
  <table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan="27">&nbsp;</td>
    <td><img src="/cfmx/sif/imagenes/tabs/spacer.gif" width="1" height="226" border="0" alt=""></td>
  </tr>
</table>
</body>
</html>
