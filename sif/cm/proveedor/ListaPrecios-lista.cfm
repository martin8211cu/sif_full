<cf_templateheader title="Compras - Lista de Precios">
		
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Lista de Precios'>
					  
					<script language="JavaScript1.2" type="text/javascript">
						function MM_findObj(n, d) { //v4.01
							var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
								d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
							if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
							for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
							if(!x && d.getElementById) x=d.getElementById(n); return x;
						}
						
						function funcNuevo(){
							document.lista.action = 'ListaPrecios.cfm';
							document.lista.submit();
						}
					</script>
						  
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td colspan="2">
								<cfinclude template="pNavegacion.cfm">
							</td>
						</tr>
					
						<tr> 
							<td colspan="2"> 
								<!--------------------------->
								<!--- Creacion del Filtro --->
								<!--------------------------->
								<cfset filtroa = ''> 
								<cfset filtrob = ''>
								 
								<cfif isdefined("form.fListaPrecios") and len(trim(fListaPrecios)) >
									<cfset filtroa = " and upper(a.ECdescripcion) like '%#Ucase(form.fListaPrecios)#%' " >
								</cfif>
									
								<cfif isdefined("form.fListaPrecios") and len(trim(fListaPrecios)) >
									<cfset filtroa = " and upper(a.ECdescripcion) like '%#Ucase(form.fListaPrecios)#%' " >
								</cfif>
								
								<cfif isdefined("form.fListaPrecios") and len(trim(fListaPrecios)) >
									<cfset filtroa = " and upper(a.ECdescripcion) like '%#Ucase(form.fListaPrecios)#%' " >
								</cfif>
									
								<cfquery name="rsLista" datasource="sifpublica">
									select ELPid, ELPUsucodigo, CEcodigo, ELPdescripcion, ELPfdesde, ELPfhasta,
										case when Estado = 1 then 'Activo' when Estado = 2 then 'Inactivo' end as Estado
									from EListaPrecios
									where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#"> 
								</cfquery>
								
								<cfinvoke 
								 component="sif.Componentes.pListas"
								 method="pListaQuery"
								 returnvariable="pListaRet">
									<cfinvokeargument name="query" value="#rsLista#"/>
									<cfinvokeargument name="desplegar" value="ELPdescripcion, ELPfdesde, ELPfhasta, Estado"/>
									<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Fecha de Inicio, Fecha de Vencimiento, Estado"/>
									<cfinvokeargument name="formatos" value="V, D, D, V"/>
									<cfinvokeargument name="align" value="left, left, left, left"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="checkboxes" value="N"/>
									<cfinvokeargument name="Nuevo" value="ListaPrecios.cfm"/>
									<cfinvokeargument name="irA" value="ListaPrecios.cfm"/>
									<cfinvokeargument name="botones" value="Nuevo"/>
									<cfinvokeargument name="showEmptyListMsg" value="true"/>
									<cfinvokeargument name="maxRows" value="0"/>
									<cfinvokeargument name="keys" value="ELPid"/>
								</cfinvoke>
							</td>
						</tr>
					</table>
					<cf_web_portlet_end>	
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>