<cf_templateheader title="Definir porcentajes por oficina">
<cfset titulo = 'Lista de detalles de Clasificación'>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">


<cfif isdefined ('url.speriodo') and not isdefined('form.Speriodo')>
		<cfset form.speriodo=#url.speriodo#>
	</cfif>
	
	<cfif isdefined ('url.smes') and not isdefined('form.Smes')>
		<cfset form.smes=#url.smes#>
	</cfif>
	
	<cfif isdefined ('url.PCCEclaid') >
		<cfset form.PCCEclaid=#url.PCCEclaid#>
	</cfif>
	
<!---Copiar valores--->
	<script language="javascript1.1" type="text/javascript">
		var popUpWinSN=0;
		function popUpWindow(URLStr, left, top, width, height){
			if(popUpWinSN) {
				if(!popUpWinSN.closed) popUpWinSN.close();
			}
			popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			window.onfocus = closePopUp;
		}
		
		function Marcar(c) {
			if (c.checked) {
				for (counter = 0; counter < document.form1.chk.length; counter++)
				{
					if ((!document.form1.chk[counter].checked) && (!document.form1.chk[counter].disabled))
						{  document.form1.chk[counter].checked = true;}
				}
				if ((counter==0)  && (!document.form1.chk.disabled)) {
					document.form1.chk.checked = true;
				}
			}
			else {
				for (var counter = 0; counter < document.form1.chk.length; counter++)
				{
					if ((document.form1.chk[counter].checked) && (!document.form1.chk[counter].disabled))
						{  document.form1.chk[counter].checked = false;}
				};
				if ((counter==0) && (!document.form1.chk.disabled)) {
					document.form1.chk.checked = false;
				}
			};
		}
		
		function doConlis(){
			var LvarCHK = '';
			var LvarCHKs = '';
			if (document.form1.chk.length > 0){
			for (var i=0; i < document.form1.chk.length; i++) {
				if (document.form1.chk[i].checked) { 
					LvarCHK = document.form1.chk[i].value;
					LvarCHKs += ',' + LvarCHK.split('|')[0];
				} 
			}
			}
			LvarCHKs = LvarCHKs.substr(1);
	
			<cfoutput>
				popUpWindow("/cfmx/sif/cg/catalogos/CopiaPorcentajes1.cfm?PCCEclaid=#form.PCCEclaid#&smes=#smes#&speriodo=#speriodo#&params="+LvarCHKs,300,300,350,200);<!---350*200--->
			</cfoutput>
		}
		
		function closePopUp(){
			if(popUpWinSN) {
				if(!popUpWinSN.closed) popUpWinSN.close();
				popUpWinSN=null;
			}
		}
		
		function funcfiltro(){
		<cfoutput>
			document.form1.action='ListaDetalles.cfm?PCCEclaid=#form.PCCEclaid#&smes=#smes#&speriodo=#speriodo#&irA=detalles';
			document.form1.submit();
		</cfoutput>
		}
	</script>
<cfoutput>
	<cfquery name="rsDetalleCla" datasource="#session.dsn#">
		Select  d.PCCEclaid,
				d.PCCDclaid,
				d.PCCDvalor,
				d.PCCDdescripcion,
				d.PCCDactivo,
				((
					select count(1) 
					from OficinasxClasificacion 
					where 
						CGCperiodo=#form.speriodo#
						and CGCmes=#form.smes# 
						and PCCDclaid in 
								(select PCCDclaid 
								from PCClasificacionD f 					
								where  d.PCCDclaid=f.PCCDclaid) 
				)) as valor
		from PCClasificacionD d
		where PCCEclaid =#form.PCCEclaid#
	</cfquery>
	
	<cfquery name="rsEnca" datasource="#session.dsn#">
		select PCCEcodigo,PCCEdescripcion from PCClasificacionE where PCCEclaid=#form.PCCEclaid#
	</cfquery>
	
	<form name="form1" method="post" action="SQLPorcentajesOficinas.cfm">
		<input type="hidden" name="smes" value="#url.smes#" />
		<input type="hidden" name="speriodo" value="#url.speriodo#" />
		
		<table width="100%" cellpadding="0" cellspacing="0">
			<cfif isdefined ('form.speriodo') and len(trim(form.speriodo)) gt 0>
				<tr>
				<td><strong>Periodo:</strong>#form.speriodo#&nbsp;&nbsp;	
			</cfif>
				
			<cfif isdefined ('form.smes') and len(trim(form.smes)) gt 0>
				<strong>Mes:</strong>#form.smes#</td>
				</tr>
			</cfif>
			
			<cfif rsEnca.recordcount gt 0>
				<tr>
				<td><strong>Encabezado Descripci&oacute;n:&nbsp;</strong>#rsEnca.PCCEcodigo#-#rsEnca.PCCEdescripcion#</td>
				</tr>
			</cfif>
			<tr>
			<td align="right">
			<cfif rsDetalleCla.recordcount gt 0>
				<input type="button" value="Copiar Valores desde Origen" id="cvt" name="cvt" onclick="doConlis()"/>
			</cfif>
				<input type="submit" value="Regresar" id="reg2" name="reg2" />
			</td>
			</tr>
			
			
		
		<tr bgcolor="CCCCCC" ><td colspan="4">&nbsp;</td>
		<tr>
			<td colspan="2"><input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);">Seleccionar Todas
			</td>
		</tr>
		
		</tr>
		<tr>		
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#rsDetalleCla#"
			columnas="PCCDclaid,PCCEclaid,PCCDvalor,PCCDdescripcion,valor"
			desplegar="PCCDvalor,PCCDdescripcion,valor"
			etiquetas="Valor,Descripci&oacute;n,Registrados"
			formatos="S,S,S"
			align="left,left,left"
			ira="formPorcentajesOficinas.cfm?speriodo=#form.speriodo#&smes=#form.smes#"
			form_method="post"
			showEmptyListMsg="yes"
			incluyeForm="false"
			formName="form1"	
			PageIndex="1"
			keys="PCCDclaid"
			checkboxes="S"	
			MaxRows="12"
			showLink="yes"
			navegacion="speriodo=#form.speriodo#&smes=#form.smes#&PCCEclaid=#form.PCCEclaid#"/>		
		</tr>
		
</form>			
	</table>
</cfoutput>

<cf_web_portlet_end>
<cf_templatefooter>