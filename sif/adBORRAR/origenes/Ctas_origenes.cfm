<!--- <cfdump var="#Form#">
 --->
<cfif not isdefined("Form.Oorigen") and isdefined("url.Oorigen")>
	<cfset Form.Oorigen = url.Oorigen>
</cfif>

<cfif not isdefined("Form.modo")>
	<cfset modo="ALTA">
<cfelseif #Form.modo# EQ "CAMBIO">
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfquery name="rsOrigen" datasource="#Session.DSN#">
	select Cdescripcion from ConceptoContable 
	where Oorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Oorigen#">
	and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rslista" datasource="#Session.DSN#">
	select a.Oorigen,a.Cmayor, b.Cdescripcion,
		coalesce ((
						select min(cpv.CPVformatoF)
						from CPVigencia cpv
						where cpv.Ecodigo = b.Ecodigo
						  and cpv.Cmayor = b.Cmayor
						  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between CPVdesde and CPVhasta
						), {fn concat (b.Cmascara, '//')} ) as Cmascara
	from OrigenCtaMayor a, CtasMayor b
	where a.Ecodigo = b.Ecodigo
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.Cmayor= b.Cmayor
	and a.Oorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Oorigen#">
</cfquery>	

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_SIFAdministracionDelSistema"
Default="SIF - Administraci&oacute;n del Sistema"
XmlFile="/sif/generales.xml"
returnvariable="LB_SIFAdministracionDelSistema"/>
<cf_templateheader title="#LB_SIFAdministracionDelSistema#">

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Parametrizaci&oacute;n de Origenes Contables">
		<cfinclude template="../../portlets/pNavegacionAD.cfm">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>	
				<td  width="50%" valign="top">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td  align="center" bgcolor="#CCCCCC" valign="top"><font size="2">Origen:&nbsp;<strong><cfoutput> #Form.Oorigen#-#rsOrigen.Cdescripcion#</cfoutput></strong></font></td>
						</tr>
						<tr>	
							<td  valign="top">
									<cfinvoke
											component="sif.Componentes.pListas"
											method="pListaQuery"
											returnvariable="pListaRet"> 
										<cfinvokeargument name="query" value="#rsLista#"/> 
										<cfinvokeargument name="desplegar" value="Cmayor,Cdescripcion,Cmascara"/>
										<cfinvokeargument name="etiquetas" value="Cuenta Mayor,Descripci&oacute;n,Mascara"/>
										<cfinvokeargument name="formatos" value="V,V,V"/>
										<cfinvokeargument name="align" value="left,left,left"/>
										<cfinvokeargument name="ajustar" value="N"/> 
										<cfinvokeargument name="checkboxes" value="N"/> 
										<cfinvokeargument name="irA" value="Ctas_origenes.cfm"/>
										<cfinvokeargument name="keys" value="Oorigen,Cmayor"/> 
										<cfinvokeargument name="showEmptyListMsg" value="true"/>						
										<cfinvokeargument name="maxrows" value="10"/>
										<cfinvokeargument name="showlink" value="true"/>
									</cfinvoke>									
		
							</td>
						</tr>	
					</table>
				</td>
				<td   align="center" valign="top"><cfinclude template="formCtas_origenes.cfm"></td>
			</tr>	

		</table>

<cf_web_portlet_end>
<cf_templatefooter>