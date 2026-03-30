<cfif form.USUARIO neq 'JEFECFNM'>
	<cfif isdefined("url.RHPcodigo") and not isdefined("form.RHPcodigo")>
		<cfset form.RHPcodigo = url.RHPcodigo >
	</cfif>
	
	<cfset modoTab2 = 'ALTA'>
	
	<cfif isdefined("form.RHDDVlinea") and len(trim(form.RHDDVlinea))>
		<cfset modoTab2 = 'CAMBIO'>	
	</cfif>
	
	
	<cfif modoTab2 EQ 'CAMBIO'>
		<cfquery name="data" datasource="#Session.DSN#">
			select x.Ecodigo, a.RHEDVid, a.RHDDVlinea, a.RHDDVvalor, a.RHDVPorden, a.BMUsucodigo, a.fechaalta,a.RHDPPid,x.RHPcodigo
			from RHDVPuestoP a, RHPuestos b , RHDescripPuestoP x
			where 	a.RHDPPid = x.RHDPPid
			and  	x.Ecodigo = b.Ecodigo 
			and     x.RHPcodigo = b.RHPcodigo
			and 	a.RHDPPid    = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
			and 	x.Ecodigo    = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">
			and 	a.RHDDVlinea = <cfqueryparam value="#form.RHDDVlinea#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>
	
	<cfquery name="rsLista" datasource="#session.DSN#">
		select  a.RHDPPid,
				a.RHDDVlinea, 
				a.RHEDVid,	
				a.RHDVPorden,
				b.RHDDVcodigo,
				b.RHDDVdescripcion, 
				c.RHEDVdescripcion,
				c.RHEDVcodigo,
				'#form.o#' as o, '#form.sel#' as sel , '#form.USUARIO#' as usuario
		from  RHDVPuestoP a								
				inner join RHDescripPuestoP x
					on a.RHDPPid = x.RHDPPid
				left outer join RHDDatosVariables b
					on a.RHDDVlinea = b.RHDDVlinea
					and x.Ecodigo = b.Ecodigo
				left outer join RHEDatosVariables c
					on a.RHEDVid = c.RHEDVid
					and x.Ecodigo = c.Ecodigo	
				left outer join RHPuestos d
					on x.Ecodigo = d.Ecodigo
					and x.RHPcodigo = d.RHPcodigo 
		where a.RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
			and x.Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">
		order by b.RHDDVdescripcion				
	</cfquery>
	
	
	<table width="100%">
		<tr>
			<td width="49%" valign="top">								
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Valor"
					Default="Valor"
					returnvariable="LB_Valor"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Descripcion"
					Default="Descripci&oacute;n"
					XmlFile="/rh/generales.xml"
					returnvariable="LB_Descripcion"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_DatoVariable"
					Default="Dato Variable"
					returnvariable="LB_DatoVariable"/>				
					<fieldset><legend><cf_translate key="LB_DatosVariables" >Datos Variables</cf_translate></legend>
					<table width="100%" border="0">
						<tr>
							<td>
							<cfinvoke
									component="rh.Componentes.pListas"
									method="pListaQuery"
									returnvariable="pListaRet"> 
								<cfinvokeargument name="query" value="#rsLista#"/> 
								<cfinvokeargument name="desplegar" value="RHDDVcodigo, RHDDVdescripcion"/> 
								<cfinvokeargument name="etiquetas" value="#LB_Valor#, #LB_Descripcion# "/> 
								<cfinvokeargument name="formatos" value="S,S"/> 
								<cfinvokeargument name="align" value="left,left"/>  
								<cfinvokeargument name="ajustar" value="N"/> 
								<cfinvokeargument name="checkboxes" value="N"/> 
								<cfif form.USUARIO eq 'ASESOR'>
									<cfinvokeargument name="irA" value="PerfilPuesto.cfm"/> 
								<cfelse>
									<cfinvokeargument name="irA" value="ApruebaPerfilPuesto.cfm"/> 
								</cfif>
								<cfinvokeargument name="form" value="formTB2"/>
								<cfinvokeargument name="keys" value="RHDPPid,RHDDVlinea,usuario"/> 
								<cfinvokeargument name="showEmptyListMsg" value="true"/>
								<cfinvokeargument name="cortes" value="RHEDVcodigo"/>
								<cfinvokeargument name="navegacion" value="#navegacion#"/>
							</cfinvoke> 
							</td>
						</tr>
					</table>	
					</fieldset>									
			</td>
			<td valign="top" align="center">
				<form name="formTB2" method="post" action="SQLPerfilPuesto.cfm">
					<!---Input con las variables para navegar en los tabs --->
					<input name="sel" type="hidden" value="2">
					<input name="o" type="hidden" value="2">
					<input type="hidden" name="RHDPPid" value="<cfoutput>#form.RHDPPid#</cfoutput>">
					<input type="hidden" name="Observaciones" 	id="Observaciones" value="">
					<input type="hidden" name="Boton" 	        id="Boton" value="">
					<input name="USUARIO" 	 type="hidden" value="<cfoutput>#FORM.USUARIO#</cfoutput>">
					<cfif modoTab2 EQ 'CAMBIO'>
						<input type="hidden" name="RHDDVlinea" 	        id="RHDDVlinea" value="">
					</cfif>	
					
	
					<cfoutput>
					<table align="center" width="98%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td bgcolor="##A0BAD3"  colspan="2">
								<cfinclude template="frame-botones2.cfm">
							</td>
					   </tr>	
						<tr>
						<td width="2%">&nbsp;</td>
						<td valign="middle">
							<table>
								<tr>
									<td nowrap align="right"><strong><cf_translate key="LB_DatosVariables" XmlFile="/rh/generales.xml">Datos Variables</cf_translate>:</strong></td>
									<td width="87%" align="right">
										<cfset id = ""> 
										<cfif modoTab2 EQ "CAMBIO">
											<cfset id = data.RHEDVid>
										</cfif>
										<cf_rhDatosVariables idquery="#id#" tabindex="1" form="formTB2">
										<cfif modoTab2 EQ 'ALTA'>
											<cfset form.RHEDVcodigo = ''>
											<cfset form.RHEDVdescripcion = ''>
											<cfset form.RHDDVcodigo = ''>
											<cfset form.RHDDVdescripcion = ''>
										</cfif>
									</td>
								</tr>
	
								<tr>
									<td nowrap align="right"><strong><cf_translate key="LB_Valores" XmlFile="/rh/generales.xml">Valores</cf_translate>:&nbsp;</strong></td>								
									<td width="87%" align="right">
										<cfset linea = "">
										<cfif modoTab2 EQ "CAMBIO">
											<cfset linea = data.RHDDVlinea>
										</cfif>
										<cf_rhDatosVariablesD filtrado="S" idquery ="#linea#" tabindex="1" form="formTB2">
									</td>
								</tr>
								<tr>
									<td nowrap  align="right"><strong><cf_translate key="LB_Orden" XmlFile="/rh/generales.xml">Orden</cf_translate>:&nbsp;</strong></td>
									<td><input type="text" name="RHDVPorden" size="10" tabindex="1" value="<cfif modoTab2 EQ 'CAMBIO'><cfoutput>#form.RHDVPorden#</cfoutput></cfif>"></td>
								</tr>
								<tr>
								  <td nowrap align="right"><strong><cf_translate key="LB_Observacion" XmlFile="/rh/generales.xml">Observaci&oacute;n</cf_translate>:&nbsp;</strong></td>
								  <td>&nbsp;</td>
								</tr>
								<tr>
								  <td colspan="2">
										<cfif modoTab2 EQ "CAMBIO">
											<cf_sifeditorhtml name="RHDDVvalor" value="#Trim(data.RHDDVvalor)#" tabindex="1">
										<cfelse>
											<cf_sifeditorhtml name="RHDDVvalor" tabindex="1">
										</cfif>
								  </td>
								</tr>
							</table>
						</td>
						</tr>
					</table>
					</cfoutput>
				</form>
			</td>
		</tr>
	</table>
	<iframe name="frRecuperar" id="frRecuperar" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DeseaEliminarElDatoVariable"
		Default="Desea eliminar el Dato Variable?"
		XmlFile="/rh/generales.xml"
		returnvariable="MSG_DeseaEliminarElDatoVariable"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DebeSeleccionarUnDatoVariableYElValorDelMismo"
		Default="Debe seleccionar un dato variable y el valor del mismo"
		XmlFile="/rh/generales.xml"
		returnvariable="MSG_DebeSeleccionarUnDatoVariableYElValorDelMismo"/>
	
	<script language="JavaScript1.2" type="text/javascript">	
		<!--- Funcion para recuperar el valor que hay en el catálogo de datos variables --->
	<cfoutput>
		function recuperar(f) {
			var params = "?dato="+f.RHDDVlinea.value;
			var fr = document.getElementById("frRecuperar");
			fr.src = "formPuestos-recuperar.cfm"+params;
		}
		
		<!--- Función para llenar el campo de valor --->
		function fillValue(v) {
			document.formTB2.RHDDVvalor.value = v;
			<!--- Linea para inicializar nuevamente el editor con el valor deseado --->
			document.getElementById("RHDDVvalor___Frame").src=oFCKeditor_.BasePath+"editor/fckeditor.html?InstanceName=RHDDVvalor&Toolbar="+oFCKeditor_.ToolbarSet;
		}
	
		//Funcion para limpiar los campos
		function funcLimpia(){
			document.formTB2.submit();						
		}
		
		//Valida que el conlis 1 tenga datos
		function validaDatoVariable(){
			if (document.formTB2.RHEDVid.value == '' || document.formTB2.RHDDVlinea.value == ''){
				alert('#MSG_DebeSeleccionarUnDatoVariableYElValorDelMismo#');
				return false;
			}
			else{
				return true;
			}
		}
	</cfoutput>	
	</script>	
<cfelse>
	<table width="100%" border="0">
		<tr>
			<td>
			<cfquery name="rsLista" datasource="#session.DSN#">
				select  a.RHDPPid,
						a.RHDDVlinea, 
						a.RHEDVid,	
						a.RHDVPorden,
						b.RHDDVcodigo,
						b.RHDDVdescripcion, 
						c.RHEDVdescripcion,
						c.RHEDVcodigo,
						a.RHDVPorden,
						{fn concat(<cf_dbfunction name="string_part" args="a.RHDDVvalor,1,100">,'...')} as RHDDVvalor,
						'#form.o#' as o, '#form.sel#' as sel , '#form.USUARIO#' as usuario
				from  RHDVPuestoP a								
						inner join RHDescripPuestoP x
							on a.RHDPPid = x.RHDPPid
						left outer join RHDDatosVariables b
							on a.RHDDVlinea = b.RHDDVlinea
							and x.Ecodigo = b.Ecodigo
						left outer join RHEDatosVariables c
							on a.RHEDVid = c.RHEDVid
							and x.Ecodigo = c.Ecodigo	
						left outer join RHPuestos d
							on x.Ecodigo = d.Ecodigo
							and x.RHPcodigo = d.RHPcodigo 
				where a.RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
					and x.Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">
				order by b.RHDDVdescripcion				
			</cfquery>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Valor"
				Default="Valor"
				returnvariable="LB_Valor"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Descripcion"
				Default="Descripci&oacute;n"
				XmlFile="/rh/generales.xml"
				returnvariable="LB_Descripcion"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_DatoVariable"
				Default="Dato Variable"
				returnvariable="LB_DatoVariable"/>		
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Orden"
				Default="Orden"
				returnvariable="LB_Orden"/>		
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Observacion"
				Default="Observación"
				returnvariable="LB_Observacion"/>		
			<cfinvoke
					component="rh.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet"> 
				<cfinvokeargument name="query" value="#rsLista#"/> 
				<cfinvokeargument name="desplegar" value="RHDDVcodigo, RHDDVdescripcion,RHDVPorden,RHDDVvalor"/> 
				<cfinvokeargument name="etiquetas" value="#LB_Valor#, #LB_Descripcion#,#LB_Orden#,#LB_Observacion#"/> 
				<cfinvokeargument name="formatos" value="S,S,S,S"/> 
				<cfinvokeargument name="align" value="left,left,left,left"/>  
				<cfinvokeargument name="ajustar" value="N"/> 
				<cfinvokeargument name="checkboxes" value="N"/> 
				<cfinvokeargument name="form" value="formTB2"/>
				<cfinvokeargument name="keys" value="RHDPPid,RHDDVlinea,usuario"/> 
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="cortes" value="RHEDVdescripcion"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="showLink" value="false"/>
			</cfinvoke> 

			</td>
		</tr>
	</table>
</cfif>