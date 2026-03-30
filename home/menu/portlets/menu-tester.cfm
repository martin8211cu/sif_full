<cf_template>
<cf_templatearea name="title">Prueba del menu
</cf_templatearea>
<cf_templatearea name="body">
<form action="" method="get">
<table width="100%" border="1">
  <cfloop from="1" to="10" index="iii">
  <tr>
    <td>
      <select name="select" id="select"><option>HTML select</option>
      </select>   
      <select name="select" id="select" style="visibility:hidden"><option>HTML select</option>
      </select>      </td>

    <td><label for="textfield">Text</label>
      <input type="text" name="textfield" id="textfield"></td>
    <td><input name="radiobutton" type="radio" value="radiobutton" id="radiobutton">
      <label for="radiobutton">Radio</label></td>
    <td><img src="../../../sif/imagenes/agenda.gif" alt="image" width="27" height="24"></td>
    <td><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0" width="100" height="22" title="Flash Button">
      <param name="BGCOLOR" value="">
      <param name="movie" value="menu-tester-button1.swf">
      <param name="quality" value="high">
      <embed src="menu-tester-button1.swf" quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100" height="22" ></embed>
    </object></td>

    <td><iframe src="about:blank" width="200" height="50"></iframe></td>
  </tr></cfloop>
</table>
</form>

</cf_templatearea>
</cf_template>
