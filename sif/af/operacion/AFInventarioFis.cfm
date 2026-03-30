<!--- definición del modo --->
<cfset modo = "ALTA">
<cfif isdefined("url.LCAid") and len(trim(url.LCAid))>
	<cfset form.LCAid = url.LCAid>
</cfif>
<cfif isdefined("form.LCAid") and len(trim(form.LCAid))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo eq "CAMBIO">
	<cfquery name="RSInventario" datasource="#session.DSN#">
		select 
			LCAid,
			LCAdescripcion,
			LCAfecha,
			LCAfechacie,
			LCAusureg,
			LCAusucie,
			LCAusuapl, 
			a.Ocodigo,
			b.Oficodigo,
			b.Odescripcion, 
			a.CFid,
			c.CFcodigo,
			c.CFdescripcion
		from AFEListaConteoActivos a
		left outer join Oficinas b 
			on a.Ecodigo = b.Ecodigo 
			and a.Ocodigo = b.Ocodigo
		left outer join CFuncional c 
			on a.Ecodigo = c.Ecodigo 
			and a.CFid= c.CFid 
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and a.LCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LCAid#">
	</cfquery>
	
	<cfif isdefined("RSInventario.LCAusureg") and len(trim(RSInventario.LCAusureg))>
		<cfquery name="RSUsuario" datasource="#session.DSN#">
			select <cf_dbfunction name="concat" args="a.Usulogin ,'-' ,d.Papellido1 ,' ' ,d.Papellido2 ,' ' ,d.Pnombre "> as usuario
			from Usuario a , DatosPersonales d
			where a.Usucodigo = #RSInventario.LCAusureg#
			and a.datos_personales = d.datos_personales
		</cfquery>
	 </cfif>
	

	<!--- <cfdump var="#RSInventario#"> --->
</cfif>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfoutput>
<cf_templateheader title="#nav__SPdescripcion#">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>"><cfoutput>#pNavegacion#</cfoutput>
			<form action="AFInventarioFis_SQl.cfm" method="post" name="form1">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td  valign="top">
						<cf_web_portlet_start titulo="Informaci&oacute;n del inventario">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td  class="fileLabel" align="right">Descripci&oacute;n:&nbsp;</td>
									<td  >
										<input  type="text" 
												name="LCAdescripcion" 
												id="LCAdescripcion" maxlength="100" 
												size="60" 
												onFocus="this.select()"
												tabindex="1"
												value="<cfif isdefined("RSInventario.LCAdescripcion") and len(trim(RSInventario.LCAdescripcion))>#trim(RSInventario.LCAdescripcion)#</cfif>">									
									</td>
									<td  class="fileLabel" align="right">Fecha:&nbsp;</td>
									<td>
										<cfif (MODO neq "ALTA")>
											<cf_sifcalendario 
												name="LCAfecha" 
												tabindex="1"
												value="#LSDateformat(RSInventario.LCAfecha,'dd/mm/yyyy')#">
										<cfelse>
											<cf_sifcalendario 
												name="LCAfecha" 
												tabindex="1"
												value="#LSDateformat(Now(),'dd/mm/yyyy')#">
										</cfif>										
									</td>								
								</tr>
								<tr>
									<td  class="fileLabel" align="right">Oficina:&nbsp;</td>
									<td>
										<cfset ArrayOF=ArrayNew(1)>
										<cfif isdefined("RSInventario.Ocodigo") and len(trim(RSInventario.Ocodigo))> 
											<cfset ArrayAppend(ArrayOF,RSInventario.Ocodigo)>
											<cfset ArrayAppend(ArrayOF,RSInventario.Oficodigo)>
											<cfset ArrayAppend(ArrayOF,RSInventario.Odescripcion)>
										</cfif>										
										<cf_conlis
											Campos="Ocodigo,Oficodigo,Odescripcion"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,40"
											ValuesArray="#ArrayOF#" 
											Title="Lista de Oficinas"
											Tabla="Oficinas"
											Columnas="Ocodigo,Oficodigo,Odescripcion"
											Filtro=""
											Desplegar="Oficodigo,Odescripcion"
											Etiquetas="C&oacute;digo,Descripci&oacute;n"
											filtrar_por="Oficodigo,Odescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="Ocodigo,Oficodigo,Odescripcion"
											Asignarformatos="S,S,S"
											MaxRowsQuery="200"
											tabindex="1"/>										
									</td>
									<td  class="fileLabel" align="right" nowrap>Centro Funcional:&nbsp;</td>
									<td>
										<cfset ArrayCF=ArrayNew(1)>
										<cfif isdefined("RSInventario.CFid") and len(trim(RSInventario.CFid))> 
											<cfset ArrayAppend(ArrayCF,RSInventario.CFid)>
											<cfset ArrayAppend(ArrayCF,RSInventario.CFcodigo)>
											<cfset ArrayAppend(ArrayCF,RSInventario.CFdescripcion)>
										</cfif>
										
										<cf_conlis
											Campos="CFid,CFcodigo,CFdescripcion"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,40"
											ValuesArray="#ArrayCF#" 
											Title="Lista de Centros Funcionales"
											Tabla="CFuncional"
											Columnas="CFid,CFcodigo,CFdescripcion"
											Filtro=""
											Desplegar="CFcodigo,CFdescripcion"
											Etiquetas="C&oacute;digo,Descripci&oacute;n"
											filtrar_por="CFcodigo,CFdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="CFid,CFcodigo,CFdescripcion"
											Asignarformatos="S,S,S"
											MaxRowsQuery="200"
											tabindex="1"/>					
									</td>									
								</tr>
								<tr>
									<td class="fileLabel" align="right" nowrap>Usuario Responsable:&nbsp;</td>
									<td>
										<cfif (MODO eq "ALTA")>
											<cf_sifusuario
											Ecodigo="#Session.Ecodigo#" 
											tabindex="1"
											form="form1">
										<cfelse>			
											<cfif isdefined("RSUsuario.usuario") and len(trim("RSUsuario.usuario"))>
												#RSUsuario.usuario#
											</cfif>							
										</cfif>								
									</td>
									<td class="fileLabel" align="right"  nowrap>Fecha de cierre:&nbsp;</td>
									<td>
										<cfif (MODO neq "ALTA")>
											<cf_sifcalendario 
												name="LCAfechacie" 
												tabindex="1"
												value="#LSDateformat(RSInventario.LCAfechacie,'dd/mm/yyyy')#">
										<cfelse>
											<cf_sifcalendario 
												tabindex="1"
												name="LCAfechacie" 
											>
										</cfif>	
									</td>									
								</tr>								
								<tr><td colspan="4">&nbsp;</td></tr>															
								<tr>
									<td colspan="4">
									<cfif modo eq "CAMBIO">
										<cf_botones values="Nuevo,ir a la lista,Aplicar,Importar Conteo"
											names="Nuevo,lista,Aplicar,Importar"
											tabindex="1">
									<cfelse>
										<cf_botones values="Agregar,ir a la lista"
											names="Agregar,lista"
											tabindex="1">
									</cfif>
									
									</td>
								</tr>															
							</table>						
						<cf_web_portlet_end>
					</td>
				</tr>
				<tr>	
					<td valign="top">
					<cfif modo eq "CAMBIO">
					  <cf_web_portlet_start titulo="Activos del inventarios">
								<cfset columnas = "
									a.Aid,ACcodigo,Adescripcion,Aplaca,LCAcantidad,LCAfecha">
 								<cfset tabla = "
									AFDListaConteoActivos a
									inner join Activos b
										on a.Aid = b.Aid
										and a.Ecodigo = b.Ecodigo">
								<cfset filtro = "
									a.Ecodigo = #session.Ecodigo# and  LCAid =#form.LCAid#
									order by  b.ACcodigo ">
								<cfinvoke 
								component="sif.Componentes.pListas"
								method="pLista"
								returnvariable="Lvar_Lista"
								tabla="#tabla#"
								columnas="#columnas#"
								desplegar="Adescripcion,Aplaca,LCAcantidad,LCAfecha"
								etiquetas="Activo,Placa,Cantidad,Fecha"
								formatos="S,S,M,D"
								filtro="#filtro#"
								incluyeform="false"
								keys="Aid"
								align="left,left,right,left"
								maxrows="25"
								showlink="false"
								formname="form1"
								ira=""
								showemptylistmsg="true"
								navegacion="LCAid=#form.LCAid#"	
								funcion="window.parent.verinfo"
     							fparams="Aid"
								/>
					  <cf_web_portlet_end>
					</cfif>
					</td>
				</tr>
			</table>
				<input name="LCAid"  value="<cfif (MODO neq "ALTA")>#form.LCAid#</cfif>" type="hidden">
			</form>
		<cf_web_portlet_end>
	<cf_templatefooter>

<!--- Validaciones del Form --->
<cf_qforms>
<script language="javascript" type="text/javascript">

	//1. Definir las descripciones de los objetos
	objForm.LCAdescripcion.description = "#JSStringFormat('Descripción')#";
	objForm.LCAfecha.description = "#JSStringFormat('Fecha')#";
	objForm.Ocodigo.description = "#JSStringFormat('Oficina')#";
	objForm.CFid.description = "#JSStringFormat('Centro funcional')#";
	<cfif (MODO eq "ALTA")>
		objForm.Usucodigo.description = "#JSStringFormat('Usuario responsable')#";
	</cfif>
	objForm.LCAfechacie.description = "#JSStringFormat('Fecha de cierre')#";


	//2. Definir la función de validacion
	function habilitarValidacion(){
		objForm.LCAdescripcion.required="true";
		objForm.LCAfecha.required="true";
		<cfif (MODO eq "ALTA")>
			objForm.Usucodigo.required="true";
		</cfif>
		objForm.LCAfechacie.required="true";
		
	}
	
	//3. Definir la función de desabilitar la validacion
	function deshabilitarValidacion(){
		objForm.LCAdescripcion.required="false";
		objForm.LCAfecha.required="false";
		<cfif (MODO eq "ALTA")>
			objForm.Usucodigo.required="false";
		</cfif>
		objForm.LCAfechacie.required="false";
	}
	
	function funcAgregar(){
		habilitarValidacion();
	}
	
	function funcImportar(){
		deshabilitarValidacion();
	}
	
	function verinfo(llave){

		//var PARAM  = "CTRC_AprobacionTrasladosDet.cfm?AFTRid="+ llave
		//open(PARAM,'','left=300,top=150,scrollbars=yes,resizable=yes,width=400,height=400')
	}	
</script>
</cfoutput>