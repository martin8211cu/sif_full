<cfif LvarTESTILestado EQ 0>
	<cfset LvarAction = "Transferencias.cfm">
	<cfset LvarTitulo = "Lista de Transferencias Intercompañías">
<cfelse>
	<cfset LvarAction = "Pagos.cfm">
	<cfset LvarTitulo = "Lista de Pagos Intercompañías">
</cfif>

<cf_web_portlet_start border="true" titulo="#Titulo#" skin="#Session.Preferences.Skin#">
	<cfoutput>
	<form name="form1" action="#LvarAction#" method="post" style="margin:0">
	</cfoutput>
		<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0" >
			<tr>
				<td class="tituloListas" nowrap align="left">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Trabajar con Tesorer&iacute;a:</strong>&nbsp;
					<cf_cboTESid onchange="this.form.submit();" tabindex="1"></td>
			</tr>
			<tr> 
				<td> 
					<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pLista"
						 returnvariable="pListaRet">
					  <cfinvokeargument name="tabla"  	  		value="TEStransfIntercomL l"/>
					  <cfinvokeargument name="columnas"			value="TESTILid, TESTILfecha, TESTILdescripcion,
																		(select count(1) from TEStransfIntercomD where TESid=l.TESid and TESTILid=l.TESTILid) as cantidad,
																		coalesce((select sum(TESTIDmontoOri*TESTIDtipoCambioOri) from TEStransfIntercomD where TESid=l.TESid and TESTILid=l.TESTILid),0.00) as total"/>
					  <cfinvokeargument name="filtro" 			value="TESid =  #session.Tesoreria.TESid#
																		  and TESTILaplicado = 0
																		  and TESTILestado = #LvarTESTILestado#"/>
					  <cfinvokeargument name="desplegar"  		value="TESTILid,TESTILdescripcion,TESTILfecha,Cantidad,Total"/>
					  <cfinvokeargument name="filtrar_por_array" value="#ListToArray('TESTILid|TESTILdescripcion|TESTILfecha|(select count(1) from TEStransfIntercomD where TESid=l.TESid and TESTILid=l.TESTILid)|coalesce((select sum(TESTIDmontoOri*TESTIDtipoCambioOri) from TEStransfIntercomD where TESid=l.TESid and TESTILid=l.TESTILid),0.00)','|')#"/>
					  <cfinvokeargument name="etiquetas" 	 	value="Num.,Descripci&oacute;n,Fecha,Cantidad,Total"/>
					  <cfinvokeargument name="formatos"   		value="I,S,D,I,M"/>
					  <cfinvokeargument name="align"      		value="right, left, left, right, right"/>
					  <cfinvokeargument name="ajustar"    		value="N"/>
					  <cfinvokeargument name="checkboxes" 		value="N"/>
					  <cfinvokeargument name="Nuevo"      		value="#LvarAction#"/>
					  <cfinvokeargument name="irA"        		value="#LvarAction#"/>
					  <cfinvokeargument name="botones"    		value="Nuevo"/>
					  <cfinvokeargument name="showEmptyListMsg" value="true"/>
					  <cfinvokeargument name="keys"       		value="TESTILid"/>
					  <cfinvokeargument name="mostrar_filtro" 	 value="true"/>
					  <cfinvokeargument name="filtrar_automatico" value="true"/>
					  <cfinvokeargument name="formName" 		  value="form1"/>
					  <cfinvokeargument name="incluyeForm" 		  value="false"/>
					</cfinvoke>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	</form>
	<cf_web_portlet_end>
<script language="JavaScript1.2" type="text/javascript">
	document.form1.TESid.focus();		
</script>