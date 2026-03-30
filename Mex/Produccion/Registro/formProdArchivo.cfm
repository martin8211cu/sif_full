
<cfif isdefined("Form.OTcodigo") AND Len(Trim(Form.OTcodigo)) GT 0>
    <cfquery name="rsProdArchivo" datasource="#session.DSN#">
        select AAnombre,AAdefaultpre,AAcontenido,AAconsecutivo, ts_rversion as SStimestamp 
        from Prod_OTArchivo 
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#">
    </cfquery>
	<cfquery dbtype="query" name="eldefault">
    	select AAconsecutivo from rsProdArchivo
        where AAdefaultpre = 1
    </cfquery>
	<cfoutput>
    <cfset NumprodArea = #rsProdArea.recordCount# >
    <form method="post" name="form" style="margin:0" action="SQLOrdenTr1.cfm" enctype="multipart/form-data">    
        <input type="hidden" name="OTCodigo" value= "#Form.OTcodigo#" />
        <input name="tab" type="hidden" value="arc">
        <table align="center" width="100%" cellpadding="0" cellspacing="0">
            <tr> 
                <td class="tituloListas" width="1%" colspan="3" align="center">Archivos Adjuntos</td>
            </tr>
            <tr>
                <td class="tituloListas" align="left" width="1%">Seleccionar vista previa</td>
                <td class="tituloListas" align="center" width="1%">Archivo</td>
                <td class="tituloListas" align="left" width="1%" >&nbsp;
                </td>
            </tr>
            <cfloop query="rsProdArchivo">
            <tr>
                <td>
                    <input type="radio" name="Prod_tipo" id="Prod_tipo#CurrentRow#" align="left" value="#rsProdArchivo.AAconsecutivo#"
                    onclick="showImage(this.value)"
                    <cfif "#rsProdArchivo.AAdefaultpre#" eq "1"> checked </cfif> >
                </td>
                <td>
                    <label for="Prod_tipo#CurrentRow#" onmouseover="showImage1(#rsProdArchivo.AAconsecutivo#)"># HTMLEditFormat( AANombre )#</label>
                </td>
                <cfif CurrentRow is 1>
                    <td align="left" width="1%" rowspan="#rsProdArchivo.RecordCount#">
<!---                    img_ot.cfm?o=#htmleditformat(form.OTcodigo)#&t=#eldefault.AAconsecutivo#
--->                    <img id="preview1" src="img_ot.cfm?o=#htmleditformat(form.OTcodigo)#&t=#eldefault.AAconsecutivo#" width="122" height="78" />
                    </td>
                </cfif>
            </tr>
            </cfloop>
            <tr height="10%">
                <td align="right" class="etiquetaCampo"><strong>Agregar:&nbsp;</strong></td>
                <td align="left" colspan="2">
                    <input name="logo" type="file" id="logo" onChange="previewLogo(this.value)">
                </td>
            </tr>
            
            <tr>
                <td align="center" valign="top" colspan="3">
                  <cfset imagesrc = "blank.gif">
                  <cfif Len(rsProdArchivo.AAcontenido) GT 1>
                    <cfinvoke 
                        component="sif.Componentes.DButils"
                        method="toTimeStamp"
                        returnvariable="tsurl">
                        <cfinvokeargument name="arTimeStamp" value="#rsProdArchivo.SStimestamp#"/>
                    </cfinvoke>
                    <cfset imagesrc = "img_ot.cfm?o=" & URLEncodedFormat(form.OTcodigo) & 
						"&t=" & URLEncodedFormat(rsProdArchivo.AAconsecutivo) & 
						"&ts=" & tsurl>
                  </cfif>
                  <img src="#imagesrc#" name="logo_preview" id="logo_preview" border="0" width="245" height="155">
                </td>
			</tr>
            <tr> 
                <td colspan="3"><div align="center"> <input type="submit" name="Aceptar" value="Añadir"> 
 													 <input type="submit" name="EliminarArchivo" value="Eliminar" > </div> 
                </td>
            </tr>
		</table>
    </form>
    </cfoutput>
</cfif>
<cfoutput>
<script language="JavaScript1.2" type="text/javascript">
	function previewLogo(value) {
		var logo = document.all ? document.all.logo_preview : document.getElementById('logo_preview');
		logo.src = value;
	}
	<cfif IsDefined('form.OTcodigo')>
	function showImage(t) {
		var logo = document.all ? document.all.logo_preview : document.getElementById('logo_preview');
		logo.src = "img_ot.cfm?o=#URLEncodedFormat(form.OTcodigo)#&sd=1&t=" + escape(t) + "&rand=" + Math.random();
	}
	function showImage1(t) {
		var logo = document.all ? document.all.preview1 : document.getElementById('preview1');
		logo.src = "img_ot.cfm?o=#URLEncodedFormat(form.OTcodigo)#&t=" + escape(t);
	}
	</cfif>
</script>
</cfoutput>