
<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
<cfset val = objParams.GetParametroInfo('30000109')>

<cfif val.codigo eq ''><cfthrow message="El parametro 30000109 no esta definido"></cfif>

<cfset vsPath_R = "#GetContextRoot()#">
<cfif REFind('(cfmx)$',vsPath_R) gt 0> 
	<cfset vsPath_R = "#vsPath_R#/">
<cfelse> 
	<cfset vsPath_R = "#vsPath_R#/cfmx/">
</cfif>
<cfset vsPath_Func = "#vsPath_R#home/public/FuncUploadImgPublicidadTC.cfm">
<cfset vsPath_Iframe = "#vsPath_R#home\public\FuncUploadImgPublicidadTC.cfm">
<cfset vsPath_Img = "..\..\..\..\Enviar\publicidad.jpg">

<cfoutput>

<input type="hidden" name="f_30000109" value="#val.valor#">
<input type="hidden" name="binary_img" value="">

<table>
    <tr>
        <td align="center">
            <input type="file" name="fileToUpload" id="fileToUpload" accept="image/*">
            <button name="btnIMG" type="button" onclick="saveImage()"><i class="fa fa-save"></i> Guardar Imagen</button>
        </td>
        <td align="center">
            <iframe name="imgPublicidadTC_iframe" id="imgPublicidadTC_iframe" src="#vsPath_Iframe#" style="border:0; border:none;" <!---width="800px" height="600px"--->>
            </iframe>
            <!---<img src="#vsPath_Img#" height="100">--->
        </td>
    </tr>
</table>

<script language = "JavaScript">
	function saveImage(){
        
        if (typeof window.FileReader !== 'function') {
            alert("The file API isn't supported on this browser yet.");
        }else{
            var files = document.getElementById("fileToUpload");
            var img = files.files[0];
            var reader = new FileReader();
            var result = reader.readAsDataURL(img);
            setTimeout(function () {
                document.getElementsByName('binary_img')[0].value = reader.result;
                document.form1.action = '#vsPath_Func#';
                document.form1.onsubmit = "return false;";
                document.form1.target = "imgPublicidadTC_iframe";
                document.form1.submit();
            }, 1000);
            setTimeout(function () {
                document.getElementById('imgPublicidadTC_iframe').src = document.getElementById('imgPublicidadTC_iframe').src;
            }, 2000);

        }

	}
</script>

</cfoutput>