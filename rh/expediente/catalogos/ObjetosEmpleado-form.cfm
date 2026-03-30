<cfparam default="-1" name="Form.DEid">
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Descripcion"
	Default="Descripci&oacute;n"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Descripcion2"
	Default="Descripción"
	returnvariable="LB_Descripcion2"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Objeto"
	Default="Objeto"
	returnvariable="LB_Objeto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Tipo"
	Default="Tipo"
	returnvariable="LB_Tipo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Filtrar"
	Default="Filtrar"
	returnvariable="LB_Filtrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Fecha"
	Default="Fecha"
	returnvariable="LB_Fecha"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Modificar"
	Default="Modificar"
	returnvariable="LB_Modificar"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Eliminar"
	Default="Eliminar"
	returnvariable="LB_Eliminar"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Descargar"
	Default="Descargar"
	returnvariable="LB_Descargar"/>		
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Objecto"
	Default="Objecto"
	returnvariable="LB_Objecto"/>			
	

<table width="100%" border="0" cellspacing="0" cellpadding="0">	
<tr>
	<td width="60%">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">	
			<tr>
				<td>
					<cfoutput>
					<form name="formFiltroListaARch" method="post" action="expediente-cons.cfm">
					<input type="hidden" name="DEid" value="#form.DEid#">
					<input name="sel" type="hidden" value="1">
					<input type="hidden" name="o" value="10">				
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
					  <tr> 
						<td class="fileLabel">#LB_Descripcion#</td>
						<td class="fileLabel">#LB_Tipo#</td>
						<td rowspan="2">
							<input name="btnFiltrarAnot" type="submit" id="btnFiltrarAnot4" value="#LB_Filtrar#">
						</td>
					  </tr>
					  <tr> 
						<td><input name="txtRHAEdescr" type="text" id="txtRHAEdescr" size="55" maxlength="100" value="<cfif isdefined('form.txtRHAEdescr')>#form.txtRHAEdescr#</cfif>"></td>
						<td>
							<cfquery name="rstipos" datasource="#session.DSN#">
								select distinct RHAEtipo
								from RHArchEmp
								where  DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">  
								order by RHAEtipo
							</cfquery>
							<select name="RHAEtipoFiltro">
								<option value="" ><cf_translate key="LB_TODOS" >Todos</cf_translate></option>
								<cfif rstipos.recordCount GT 0>
									<cfloop query="rstipos">
										<option value="#rstipos.RHAEtipo#" <cfif isdefined('form.RHAEtipoFiltro') and form.RHAEtipoFiltro EQ rstipos.RHAEtipo> selected</cfif>>#rstipos.RHAEtipo#</option>
									</cfloop>
								</cfif>
							</select>
						</td>
					  </tr>
					</table>
				  </form>
				  </cfoutput>
				</td>
			</tr>
			<tr>
				<td>
					<cf_dbfunction name="to_char" args="RHAEid" returnvariable="vRHAEid">

					<cfquery name="rsLista" datasource="#session.DSN#">
						select RHAEid,DEid,RHAEdescr,RHAEfecha,RHAEarchivo,
						{fn concat('<a href="javascript: Editar(''',{fn  concat(#vRHAEid#,''');"><img alt=''#LB_Modificar#'' src=''/cfmx/rh/imagenes/iindex.gif'' border=''0''></a>')})} as Editar,
						{fn concat('<a href="javascript: Descargar(''',{fn  concat(#vRHAEid#,''');"><img alt=''#LB_Descargar#'' src=''/cfmx/rh/imagenes/Cfinclude.gif'' border=''0''></a>')})} as Descargar, 
						10 as o,
						1  as sel
						from RHArchEmp 
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">  
						<cfif isdefined("form.txtRHAEdescr") and len(trim(form.txtRHAEdescr))>
								and upper(RHAEdescr)  like '%#UCase(Form.txtRHAEdescr)#%'
						</cfif>
						<cfif isdefined("form.RHAEtipoFiltro") and len(trim(form.RHAEtipoFiltro))>
							and RHAEtipo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHAEtipoFiltro#">  
						</cfif>
						
						order by RHAEfecha desc
					</cfquery>
					<cfset navegacionArch = "">
					<cfset navegacionArch = navegacionArch & Iif(Len(Trim(navegacionArch)) NEQ 0, DE("&"), DE("")) & "o=10">
					<cfinvoke 
					 component="rh.Componentes.pListas"
					 method="pListaQuery"
					 returnvariable="pListaFam">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="RHAEfecha,RHAEdescr,RHAEarchivo,Editar,Descargar"/>
						<cfinvokeargument name="etiquetas" value="#LB_Fecha#,#LB_Descripcion#,#LB_Objeto#,&nbsp;,&nbsp;"/>
						<cfinvokeargument name="formatos" value="D,S,S,V,V"/>
						<cfinvokeargument name="formName" value="listaArchivos"/>	
						<cfinvokeargument name="align" value="left,left,left,center,center"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="keys" value="RHAEid"/>	
						<cfinvokeargument name="showLink" value="false"/>	
						<cfinvokeargument name="irA" value="expediente-cons.cfm"/>			
						<cfinvokeargument name="navegacion" value="#navegacionArch#"/>
					</cfinvoke>
				</td>
			</tr>
		</table>	
	</td>
	<td width="40%" >
		<cfset modo = 'ALTA'>
		<cfif isdefined("form.RHAEid") and len(trim(form.RHAEid))>
			<cfset modo = 'CAMBIO'>
		</cfif>	
		<cfif modo NEQ 'ALTA'>
			<cfquery name="rsdataObj" datasource="#session.DSN#">
				select RHAEid,DEid,RHAEdescr,RHAEfecha,RHAEtipo,RHAEruta, ts_rversion
				from RHArchEmp
				where  RHAEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAEid#">  
			</cfquery>
		</cfif>
		<cfoutput>
			<form name="form1" method="post" enctype="multipart/form-data" action="SQLObjetosEmpleado.cfm" onSubmit="return validar();" >
				<table>
					<tr>
						<td align="right" nowrap><strong><cf_translate  key="LB_Descripcion">Descripci&oacute;n</cf_translate>:</strong>&nbsp;</td>
						<td><input type="text" name="RHAEdescr"  value="<cfif modo neq 'ALTA'>#HTMLEditFormat(rsdataObj.RHAEdescr)#</cfif>" size="45" maxlength="100"></td>
					</tr>	
					<tr>
						<td align="right" nowrap><strong><cf_translate  key="LB_Fecha">Fecha</cf_translate>:</strong>&nbsp;</td>
						<td>
							<cfif modo NEQ 'ALTA'>
								<cfset fecha = LSDateFormat(rsdataObj.RHAEfecha, "DD/MM/YYYY")>
							<cfelse>
								<cfset fecha = LSDateFormat(Now(), "DD/MM/YYYY")>
							</cfif> 
							 <cf_sifcalendario form="form1" value="#fecha#" name="RHAEfecha">
						</td>
					</tr>
					<cfif modo EQ 'ALTA'>
						<tr>
							<td align="right"><strong><cf_translate  key="LB_Objeto">Objeto</cf_translate>:&nbsp;</strong></td>
							<td><input type="file" name="archivo" value="" size="35" ></td>
						</tr>
					</cfif>
					
					<tr>
						<td  colspan="2" align="center">
							<cf_botones modo=#modo# >  
						</td>
					</tr>
				</table>	
				<input type="hidden" name="DEid" value="#form.DEid#">
				<input name="sel" type="hidden" value="1">
				<input type="hidden" name="o" value="10">	
				<input type="hidden" name="BotonSel" value="">
				<input type="hidden" name="RHAEid" value="<cfif isdefined("form.RHAEid") and len(trim(form.RHAEid))>#form.RHAEid#</cfif>">	  
			</form>
		</cfoutput>	
	</td>
</tr>
</table>

 <iframe id="FRAMECJNEGRA" name="FRAMECJNEGRA" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" style="visibility:hidden"></iframe>
<!--- --->

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_SePpresentaronLosSiguientesErrores"
Default="Se presentaron los siguientes errores"
returnvariable="MSG_SePpresentaronLosSiguientesErrores"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_ESRequerido"
Default="es requerido."
returnvariable="MSG_ESRequerido"/>

<script language="JavaScript" type="text/javascript">

	function validar(){
	<cfoutput>
		var error = false;
		var mensaje = '#MSG_SePpresentaronLosSiguientesErrores#:\n';
		
		if ( document.form1.RHAEdescr.value == ''){
			error = true;
			mensaje  = mensaje + '#LB_Descripcion2# #MSG_ESRequerido#\n';									
		}
		if ( document.form1.RHAEfecha.value == ''){
			error = true;
			mensaje  = mensaje + '#LB_Fecha# #MSG_ESRequerido#\n';									
		}
		<!--- if ( document.form1.RHAEtipo.value == ''){
			error = true;
			mensaje  = mensaje + '#LB_Tipo# #MSG_ESRequerido#\n';									
		} --->
		<cfif modo EQ 'ALTA'>
			if ( document.form1.archivo.value == ''){
				error = true;
				mensaje  = mensaje + '#LB_Objecto# #MSG_ESRequerido#\n';									
			}
			</cfif>
		if (error){
			alert(mensaje);
			return false;								
		}
		</cfoutput>
		return true;
	}
	
	function Editar(llave){
		document.form1.action = 'expediente-cons.cfm'
		document.form1.RHAEid.value = llave;
		document.form1.submit();
	}
	
	function Descargar(llave){
		var RHAEid		= llave;
		params = "?RHAEid="+RHAEid;
		var frame = document.getElementById("FRAMECJNEGRA");
	    frame.src = "descargararchivo.cfm"+params;		
		
	}
</script>