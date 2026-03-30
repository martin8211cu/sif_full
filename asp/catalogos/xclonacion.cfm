<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_ClonacionEmpesas"
Default="Clonaci&oacute;n de Empresas"
XmlFile="clonacion/rh/Etiquetas.xml"
returnvariable="LB_ClonacionEmpesas"/>

<cfoutput>
	<script>
	function mostrarTD(c){
		
			var TD_EcodigoO	 = document.getElementById("tdEcodigoO");
			var TD_EcodigoD	 = document.getElementById("tdEcodigoD");
			var TD_Ayuda	 = document.getElementById("tdAyuda");
			var TD_Cuenta	 = document.getElementById("tdCuenta");
			var TD_Empresa	 = document.getElementById("tdEmpresa");
			
			if (c.checked==true){
				TD_EcodigoO.style.display = "none";
				TD_Cuenta.style.display   = "none";
				TD_Empresa.style.display  = "none";
				TD_EcodigoD.style.display = "";
				TD_Ayuda.style.display = "";
			}
			else{
				TD_EcodigoO.style.display = "";
				TD_Cuenta.style.display   = "";
				TD_Empresa.style.display  = "";
				TD_EcodigoD.style.display = "none";
				TD_Ayuda.style.display = "none";
			}
		}
	</script>
</cfoutput>

<cf_templateheader title="#LB_ClonacionEmpesas#">	
	<table width="100%" cellpadding="0" cellspacing="0">
	<tr><td>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo=#LB_ClonacionEmpesas#>
			<cfinclude template="/home/menu/navegacion.cfm">
			<cfset listadatasourse = "">
			<cfset factory = CreateObject("java", "coldfusion.server.ServiceFactory")>
			<cfset ds_service = factory.datasourceservice>
			<cfset datasources = ds_service.getDatasources()>
			
			<cfloop collection="#datasources#" item="i">
				<cftry>
					<cfset thisdatasource = datasources[i]>
					<cfset listadatasourse = listadatasourse & thisdatasource.name  & ",">
				<cfcatch type="any"></cfcatch>
				</cftry>
			</cfloop>
		
			<cfset listadatasourse = listadatasourse & "x">
			<cfset arreglo = listtoarray(listadatasourse,",")>
			
						
			<!---
			<cfset dsinfo = StructNew()>
			<cfset factory = CreateObject("java", "coldfusion.server.ServiceFactory")>
			<cfset ds_service = factory.datasourceservice>
			<cfset datasources = ds_service.getDatasources()>
			
			<cfloop collection="#datasources#" item="i">
				<cftry>
					<cfset thisdatasource = datasources[i]>
					<cfif IsDefined('thisdatasource.class')>
						<cfset dsinfoitem = StructNew()>
						<cfset dsinfoitem.name        = thisdatasource.name>
						<cfset dsinfoitem.driverClass = thisdatasource.class>
						<cfset dsinfoitem.driverName  = thisdatasource.driver>
						<cfset dsinfoitem.url         = thisdatasource.url>
						<cfset dsinfoitem.type        =  LCase(thisdatasource.driver)>
						<cfset dsinfo[datasources[i].name] = dsinfoitem>
						<cfset listadatasourse = listadatasourse & thisdatasource.name  & ",">
					</cfif>
					<cfcatch type="any"></cfcatch>
				</cftry>
			</cfloop>
			
			
			<cfset Application.dsinfo = dsinfo>
			--->

			
			<cfset listadatasourse = listadatasourse & "x">
			<cfset arreglo = listtoarray(listadatasourse,",")>
			
			<cfif isdefined("form.DSNO") and len(trim(form.DSNO)) GT 0>
				<cfif isdefined("Application.dsinfo") and Application.dsinfo[#form.DSNO#].type is 'oracle'>
					<cfset session.DSNO = #form.DSNO#&'.'>
					<cfdump var="#session.DSNO#">
				<cfelseif isdefined("Application.dsinfo") and Application.dsinfo[#form.DSNO#].type is 'sybase'>
					<cfset session.DSNO = #form.DSNO#&'..'>
				</cfif>
				<!---<cfset Empresas = #session.DSNO#&'Empresas'>--->
				
				<cfquery name="rsCEO" datasource="asp">
					select CEcodigo, CEnombre
					from CuentaEmpresarial
					where CEcodigo in (select cliente_empresarial from <cf_dbdatabase table="Empresas" datasource="#form.DSNO#">)
					order by CEnombre
				</cfquery>
				
			</cfif>

			<cfif isdefined("form.DSND") and len(trim(form.DSND)) GT 0>
				<cfif isdefined("Application.dsinfo") and Application.dsinfo[#form.DSNO#].type is 'oracle'>
					<cfset session.DSND = #form.DSND#&'.'>
					<cfdump var="#session.DSND#">
				<cfelseif isdefined("Application.dsinfo") and Application.dsinfo[#form.DSNO#].type is 'sybase'>
					<cfset session.DSND = #form.DSND#&'..'>
				</cfif>
				
				<cfset Empresas = #session.DSND#&'Empresas'>
				
				<cfquery name="rsCED" datasource="asp">
					select CEcodigo, CEnombre
						from CuentaEmpresarial
							where CEcodigo in (select cliente_empresarial from #Empresas# )
						order by CEnombre
				</cfquery>
			
				<cfif isdefined("Application.dsinfo") and Application.dsinfo[#form.DSNO#].type is 'oracle'>
					<cfset session.DSND = #form.DSNO#&'.'>
					<cfdump var="#session.DSND#">
				<cfelseif isdefined("Application.dsinfo") and Application.dsinfo[#form.DSNO#].type is 'sybase'>
					<cfset session.DSND = #form.DSNO#&'..'>
				</cfif>
			</cfif>
			
			<cfquery name="rsSSO" datasource="asp">
				select SScodigo, SSdescripcion
					from SSistemas
				order by SScodigo
			</cfquery>
			
			<cfif isdefined("form.CEcodigoO") and form.CEcodigoO GT 0>
				<cfquery name="rsEO" datasource="#form.DSNO#">
					select Ecodigo, Edescripcion
						from Empresas
							where cliente_empresarial = #form.CEcodigoO#
						order by Edescripcion
				</cfquery>
			</cfif>
			
			<cfif isdefined("form.CEcodigoD") and form.CEcodigoD GT 0>
				<cfquery name="rsED" datasource="#form.DSND#">
					select Ecodigo, Edescripcion
					from Empresas
					where cliente_empresarial = #form.CEcodigoD#
					order by Edescripcion
				</cfquery>	
			</cfif>
			<cfif not (IsDefined("form.CDPid") and Len(Trim(form.CDPid))
			and IsDefined("form.btnReporte") and Len(Trim(form.btnReporte)))>

		<script language="JavaScript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
		<form name="formfiltrosup" 	method="post" action="#currentpage#" style="margin:0">
				
			<table width="100%" align="center" style="margin:0" border ="0"	cellspacing="0"	cellpadding="0"	class="tituloListas" cols="4">
				<tr><tr><td class="etiqueta" nowrap>
							Sistema&nbsp;:&nbsp;
						<select name="SScodigoO" onchange="javascript:this.form.submit();">
							<option value=""></option>
							<cfoutput query="rsSSO">
							<cfset selected = iif(IsDefined("form.SScodigoO") and form.SScodigoO eq SScodigo,DE("selected"),DE(""))>
							<option value="#SScodigo#" #selected#>#SSdescripcion#</option>
							</cfoutput>
						</select></tr>
					</tr>
					<tr ><td><input  name="chkSQL" value="1"<cfif isdefined("form.chkSQL")>checked="checked"</cfif> type="checkbox" onClick="javascript:mostrarTD(this);">Generar SCRIPT-SQL</td></tr>
				<tr>
				
				<td width="100%" align="left">
				<table align="center" style="margin:0" border ="0" cellspacing="0" cellpadding="0" class="tituloListas" >
					<tr><td nowrap="nowrap"></td> 
						<td class="etiqueta" nowrap align="left">
							Empresa Origen						</td>
						 <td class="etiqueta" nowrap align="left">
							Empresa Destino						</td>
					</tr>
					<tr>
						<td width="1%" class="etiqueta" nowrap>
							DataSource&nbsp;:&nbsp;						</td>
						<td width="1%">
							<select name="DSNO" onchange="javascript:this.form.submit();">
								<option value= ""></option>
								<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
									<cfset selected = iif(IsDefined("form.DSNO") and form.DSNO eq #arreglo[i]#,DE("selected"),DE(""))>
									<cfoutput><option value= "#arreglo[i]#"#selected#>#arreglo[i]#</option></cfoutput>
								</cfloop>
							</select>
						</td>
						<td width="1%" id="tdEcodigoO" <cfif isdefined('form.chkSQL')>style="display:none"</cfif>>
							<select name="DSND" onchange="javascript:this.form.submit();">
								<option value= ""></option>
								<cfif isdefined("form.EcodigoO") and form.EcodigoO GT 0 >
									<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
										<cfset selected = iif(IsDefined("form.DSND") and form.DSND eq #arreglo[i]#,DE("selected"),DE(""))>
										<cfoutput><option value= "#arreglo[i]#"#selected#>#arreglo[i]#</option></cfoutput>
									</cfloop>
								</cfif>
							</select>
						</td>
						<td width="1%" id="tdEcodigoD" <cfif not isdefined('form.chkSQL')>style="display:none"</cfif>>
							Ecodigo:
							<input 
								type="text" 
								name="EcodigoDE"  
								size="5" 
								maxlength="5"
								onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
								value="<cfif isdefined("form.EcodigoDE") and len(trim(form.EcodigoDE)) gt 0 >
								<cfoutput>#form.EcodigoDE#</cfoutput></cfif>" 
								onFocus="javascript:this.select();" 
								>
								
							
						</td>
						
					</tr>
					<tr>
						<td width="1%" class="etiqueta" nowrap>
							Cuenta Empresarial&nbsp;:&nbsp;							</td>
						<td width="1%">
							<select name="CEcodigoO" onchange="javascript:this.form.submit();">
								<option value=""></option>
								<cfif isdefined("form.DSNO") and len(trim(form.DSNO)) GT 0 >
									<cfoutput query="rsCEO">
									<cfset selected = iif(IsDefined("form.CEcodigoO") and form.CEcodigoO eq CEcodigo,DE("selected"),DE(""))>
									<option value="#CEcodigo#" #selected#>#CEnombre#</option>
									</cfoutput>
								</cfif>
							</select>
					</td>
						<td width="1%" id="tdCuenta"  <cfif isdefined('form.chkSQL')>style="display:none"</cfif>>
							<select name="CEcodigoD" onchange="javascript:this.form.submit();">
								<option value=""></option>
								<cfif isdefined("form.DSND") and len(trim(form.DSND)) GT 0 >
									<cfoutput query="rsCED">
									<cfset selected = iif(IsDefined("form.CEcodigoD") and form.CEcodigoD eq CEcodigo,DE("selected"),DE(""))>
									<option value="#CEcodigo#" #selected#>#CEnombre#</option>
									</cfoutput>
								</cfif>
							</select>
						</td>
					</tr>
						<tr>
							<td class="etiqueta" nowrap>Empresa&nbsp;:&nbsp;</td>
							<td>
								<select name="EcodigoO" onchange="javascript:this.form.submit();">
									<option value=""></option>
									<cfif isdefined("form.CEcodigoO") and form.CEcodigoO GT 0>
										<cfoutput query="rsEO">
										<cfset selected = iif(IsDefined("form.EcodigoO") and form.EcodigoO eq Ecodigo,DE("selected"),DE(""))>
										<option value="#Ecodigo#" #selected#>#Edescripcion#</option>
										</cfoutput>
									</cfif>
								</select> 
								<cfif isdefined("form.EcodigoO") and form.EcodigoO GT 0>
									<cfoutput>#EcodigoO#</cfoutput>
								</cfif>
							</td>
								<td id="tdEmpresa" <cfif isdefined('form.chkSQL')>style="display:none"</cfif>>
								  <select name="EcodigoD" onchange="javascript:this.form.submit();">
                                    <option value=""></option>
									<cfif isdefined("form.CEcodigoD") and form.CEcodigoD GT 0 >
										<cfoutput query="rsED">
										  <cfset selected = iif(IsDefined("form.EcodigoD") and form.EcodigoD eq Ecodigo,DE("selected"),DE(""))>
										  <option value="#Ecodigo#" #selected#>#Edescripcion#</option>
										</cfoutput>
									</cfif>
                                  </select>
								  <cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
										<cfoutput>#EcodigoD#</cfoutput>
								  </cfif>
							  </td>
							<td valign="top" id="tdAyuda" <cfif not isdefined('form.chkSQL')>style="display:none"</cfif>>
								<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ayuda" Default="Ayuda" returnvariable="LB_ayuda"/>
								<cf_web_portlet_start tipo="mini" titulo="#LB_ayuda#" tituloalign="left" wifth="50" height="50">
								<p>
								<cf_translate  key="LB_texto_de_ayuda">
									El Ecodigo que se debe de digitar es el que esta en la tabla Empresas (minisif)
								</cf_translate>
								</p>
								<cf_web_portlet_end>
							</td>
						</tr>
				
				</table>
				</td>
				</tr>
				</table>
			</form>
		</cfif>
		<cfif (isdefined("form.EcodigoO") and form.EcodigoO GT 0) >
			<cfinclude template="clonacion-form.cfm">
		</cfif>
	</table>
	<cf_web_portlet_end>
	</td></tr>
</table>
<cf_templatefooter>

