<cfset modo = "ALTA">
<!---  --->
<cfinvoke component="rh.Componentes.RH_CargaMonedaLoc" method="Ins_Moneda_Loc" 	
	Ecodigo ="#Session.Ecodigo#">
</cfinvoke>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Monedas"
Default="Monedas"
returnvariable="LB_Monedas"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Monedas#'>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<cfinclude template="/rh/portlets/pNavegacion.cfm">					
						</td>
					</tr>
				</table>					
				<table width="100%"  border="0">
					<tr>
						<td width="50%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
								<tr>

									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_Nombre"
									Default="Nombre"
									returnvariable="LB_Nombre"/>	
									
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_Iso"
									Default="Iso"
									returnvariable="LB_Iso"/>		
									
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_Simbolo"
									Default="S&iacute;mbolo"
									returnvariable="LB_Simbolo"/>
									
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_Local"
									Default="Local"
									returnvariable="LB_Local"/>
																
									
									<form name="fBusqueda" method="post">
										<td width="11%" align="center"><strong><cfoutput>#LB_Nombre#</cfoutput></td>
										<td width="30%" align="left"><input name="Mnombre" type="text" size="20"
											value="<cfif isDefined("form.Mnombre")><cfoutput>#form.Mnombre#</cfoutput></cfif>"
											onFocus="this.select()"></td>
										<td width="7%" align="center"><strong><cfoutput>#LB_Iso#</cfoutput>:</strong></td>
										<td width="7%" align="left"><input name="Miso4217" type="text" size="5" maxlength="3"
											value="<cfif isDefined("form.Miso4217")><cfoutput>#form.Miso4217#</cfoutput></cfif>"
											onFocus="this.select()"></td>											
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Filtrar"
										Default="Filtrar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Filtrar"/>
										
										<td width="15%" align="center"><input name="btnFiltrar" type="submit" value="<cfoutput>#BTN_Filtrar#</cfoutput>"></td>
										<td width="58%" align="left">&nbsp;</td>
										<input name="modo" type="hidden">
										<input name="Mcodigo" type="hidden">
									</form>
								</tr>
							</table>		
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td  colspan="6">
										<cfquery name="rsLista" datasource="#session.DSN#">	
											select distinct 
												A.Mcodigo,
												B.Mnombre,
												B.Miso4217, 
												B.Msimbolo,
												A.Eliminable,
												{fn concat('<img border=''0'' src=''/cfmx/rh/imagenes/',{fn concat((case coalesce(C.Mcodigo,-1) when -1 then 'un' else null end),'checked.gif''>')})} as Local,									
												C.Mcodigo as MCLocal,
												case when (A.Eliminable = 0 or A.Mcodigo in (
																					select x.Mcodigo 
																					from HRCalculoNomina x ,RHTCRelacionPago y 
																					where  y.RCNid = x.RCNid
																					and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> ) or not C.Mcodigo is null)
													then ''
													else {fn concat('<img border=''0'' onClick=''eliminar(',{fn concat(<cf_dbfunction name="to_char" args="A.Mcodigo">,');'' src=''/cfmx/rh/imagenes/Borrar01_S.gif''>')})}
												end as EliminableStr
											from RHMonedas A
												inner join Monedas B on
													A.Mcodigo = B.Mcodigo and
													A.Ecodigo = B.Ecodigo
												left outer join Empresas C on 
													A.Mcodigo = C.Mcodigo
											where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

											<cfif isDefined("form.Miso4217") and len("#form.Miso4217#")>
												and upper(B.Miso4217) like upper(<cfqueryparam cfsqltype="cf_sql_char" value="%#form.Miso4217#%">)
											</cfif>								
											<cfif isDefined("form.Mnombre") and len("#form.Mnombre#")>
												and upper(B.Mnombre) like upper(<cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.Mnombre#%">)
											</cfif>								
										</cfquery> 

										<cfinvoke
											component="rh.Componentes.pListas"
											method="pListaQuery"
											returnvariable="pListaRet"
												query="#rsLista#"
												desplegar="Mnombre,Miso4217,Msimbolo,Local,EliminableStr"
												etiquetas="#LB_Nombre#,#LB_Iso#,#LB_Simbolo#,#LB_Local#,&nbsp;"
												formatos="S,S,S,S,S,S"
												align="left,left,left,center,center"
												ajustar="N"
												checkboxes="N"
												irA="RH_monedas.cfm"
												keys="Mcodigo"
												showEmptyListMsg="true"
												showlink="false"
												maxrows="10" />
									</td>								
								</tr> 
							</table>
						</td>
						<td valign="top"><cfinclude template="formRH_monedas.cfm"></td>
					</tr>
				</table>
				<cf_web_portlet_end>
			</td>
	  	</tr>
	</table>
<cf_templatefooter>

<script language="javascript" type="text/javascript">

	function eliminar(llave){
		if (confirm('¿Desea eliminar la Moneda?')){
			document.fBusqueda.modo.value = 'BAJA';
			document.fBusqueda.Mcodigo.value = llave;			
			document.fBusqueda.action = "SQLRH_monedas.cfm"
			document.fBusqueda.submit();
		}else{
			return false;
		}
	}

	document.fBusqueda.Mnombre.focus();	
</script>