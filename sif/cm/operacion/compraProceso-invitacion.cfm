<cfset navegacion = "">
<cfparam name="LvarEstadoProceso" default="0">
<cfif NOT ISDEFINED('Session.Compras.ProcesoCompra.CMPid') OR NOT LEN(TRIM(Session.Compras.ProcesoCompra.CMPid))>
	Debe seleccionar uno de los procesos de compra o crear uno nuevo antes de continuar<cfabort>
</cfif>
<!---►►Recuperar la Información del Proceso◄◄--->

<cfquery name="rsProceso" datasource="#Session.DSN#">
    select CMPfmaxofertas, CMPestado
      from CMProcesoCompra
    where CMPid = #Session.Compras.ProcesoCompra.CMPid#
</cfquery>
<cfset LvarEstadoProceso = rsProceso.CMPestado>


<cfquery name="rsPsugeridos" datasource="#session.DSN#">
	select Pvalor as cantidad
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	  and Pcodigo = 535
</cfquery>
<cfset LvarSugeridos = rsPsugeridos.cantidad>

<cffunction name="fnUrlToFormParam">
	<cfargument name="LprmNombre"  type="string" required="yes">
	<cfargument name="LprmDefault" type="string" required="yes">
	
	<cfparam name="url[LprmNombre]" default="#LprmDefault#">
	<cfparam name="form[LprmNombre]" default="#url[LprmNombre]#">
	
	<cfif isdefined("navegacion") and Len(Trim(Form[LprmNombre]))>
		<cfif len(trim(navegacion))>
			<cfset navegacion = navegacion & "&">
		</cfif>
		<cfset navegacion = navegacion & "#LprmNombre#=" & Form[LprmNombre]>
	</cfif>	
</cffunction>

<cfset fnUrlToFormParam ("txt_numero", "")>
<cfset fnUrlToFormParam ("txt_nombre", "")>
<cfset fnUrlToFormParam ("selProveedores", "")>
<cfset fnUrlToFormParam ("selecionados", "")>

<cfif modo EQ "CAMBIO">		
	<cfif lvarProvCorp>
		<cfset lvarFiltroEcodigo = Session.Compras.ProcesoCompra.Ecodigo>					
    <cfelse>
        <cfset lvarFiltroEcodigo = Session.Ecodigo>
    </cfif>
	<cfquery name="rsProveedores" datasource="#Session.DSN#">
		select a.SNcodigo, a.SNnumero, a.SNnombre, 
		(select min(p.SNFecha) from SNegocios p where p.SNcodigo = b.SNcodigo) as fecha,
			   case when b.CMPpublicado = 1 then a.SNcodigo else null end as inactive,
			   b.SNcodigo as checked
		from SNegocios a
			left outer join CMProveedoresProceso b
			on b.CMPid = #Session.Compras.ProcesoCompra.CMPid#
			and a.Ecodigo = b.Ecodigo
			and a.SNcodigo = b.SNcodigo
		where a.Ecodigo = #Session.Ecodigo#
		and a.SNtiposocio <> 'C'
		and a.SNinactivo = 0
		<cfif isdefined("Form.txt_numero") and Len(Trim(Form.txt_numero))>
		and upper(a.SNnumero) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(Form.txt_numero)#%">
		</cfif>
		<cfif isdefined("Form.txt_nombre") and Len(Trim(Form.txt_nombre))>
		and upper(a.SNnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(Form.txt_nombre)#%">
		</cfif>
		order by fecha
	</cfquery>
	<cfquery name="rsProveedoresPublicados" datasource="#Session.DSN#">
		select count(1) as cant
		from CMProveedoresProceso
		where CMPid = #Session.Compras.ProcesoCompra.CMPid#
		and Ecodigo  = #Session.Ecodigo#
		and CMPpublicado = 1
	</cfquery>
	<cfquery name="rsProveedoresSeleccionados" datasource="#Session.DSN#">
		select count(1) as cant
		  from CMProveedoresProceso
		where CMPid = #Session.Compras.ProcesoCompra.CMPid#
	</cfquery>

	<cfquery name="rsIDsolicitud" datasource="#Session.DSN#">
		select distinct ESidsolicitud 
		  from DSolicitudCompraCM
		where DSlinea in (select DSlinea from CMLineasProceso where CMPid = #Session.Compras.ProcesoCompra.CMPid#)
	</cfquery>
    <cfif NOT rsIDsolicitud.RecordCount>
    	El proceso no tienen Solicitudes de Compra Asociadas<cfabort>
    </cfif>

	<!---- Se crea una lista con todos los IDS de la solicitud incluidos en el proceso de compra ----->	
	<cfset solicitudes = ValueList(rsIDsolicitud.ESidsolicitud,',')>

	<!---- Obtener la fecha maxima de cotizacion ----->
	<cfquery name="rsFMaxima" datasource="#Session.DSN#">
		select CMPfmaxofertas
		from CMProcesoCompra
		where CMPid = #Session.Compras.ProcesoCompra.CMPid#
	</cfquery>
	
	<!--- Carga de proveedores en una variable ---->
<cfset proveedores = ValueList(rsProveedores.SNcodigo,',')>

	<cfquery name="rsProv" datasource="#Session.DSN#">
			select Distinct
				coalesce((select max(pu.fechaalta) from CMProveedoresProceso pu where pu.SNcodigo = b.SNcodigo),
				(select min(p.SNFecha) from SNegocios p where p.SNcodigo = b.SNcodigo)) as fechaalta,	
				
				a.SNcodigo as checked, 
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as inactive, 
				a.SNcodigo,  
				b.SNnumero,
				b.SNnombre 
			from NumParteProveedor a				
				inner  join SNegocios b
					on a.SNcodigo = b.SNcodigo
					and a.Ecodigo = b.Ecodigo		
			where a.Ecodigo = #Session.Ecodigo#
				and a.Aid in ( select x.Aid
								from DSolicitudCompraCM x
								inner join CMLineasProceso  y
									on x.DSlinea = y.DSlinea
									and y.CMPid =	#Session.Compras.ProcesoCompra.CMPid#  
								where  x.Ecodigo = #Session.Ecodigo#
									and x.Aid is not null
									and x.ESidsolicitud in(#solicitudes#))	
	union
		
			select 	
				coalesce((select max(pu.fechaalta) from CMProveedoresProceso pu where pu.SNcodigo = e.SNcodigo),
				(select min(p.SNFecha) from SNegocios p where p.SNcodigo = e.SNcodigo)) as fechaalta,	
				
				d.SNcodigo as checked, 
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as inactive, 
				d.SNcodigo,
				e.SNnumero,
				e.SNnombre
			from DSolicitudCompraCM a
				left outer join Articulos b
					on a.Aid = b.Aid
					and a.Ecodigo = b.Ecodigo
				inner join Clasificaciones c
					on b.Ccodigo = c.Ccodigo
					and b.Ecodigo = c.Ecodigo
				inner  join ClasificacionItemsProv d
					on c.Ccodigo = d.Ccodigo
					and a.Ecodigo = d.Ecodigo
				inner join SNegocios e
					on d.SNcodigo = e.SNcodigo
					and d.Ecodigo = e.Ecodigo
			where  a.Ecodigo = #Session.Ecodigo#
					and a.Aid in ( select x.Aid
								    from DSolicitudCompraCM x
										inner join CMLineasProceso  y
											on x.DSlinea = y.DSlinea
											and y.CMPid = #Session.Compras.ProcesoCompra.CMPid#  
									where  x.Ecodigo = #Session.Ecodigo#
										and x.Aid is not null
										and x.ESidsolicitud in(#solicitudes#))

 	union			
			select 	
				coalesce((select max(pu.fechaalta) from CMProveedoresProceso pu where pu.SNcodigo = e.SNcodigo),
				(select min(p.SNFecha) from SNegocios p where p.SNcodigo = e.SNcodigo)) as fechaalta,	
				
				d.SNcodigo as checked, 
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as inactive, 
				d.SNcodigo,
				e.SNnumero,
				e.SNnombre
			from DSolicitudCompraCM a
				left outer join Conceptos b
					on a.Cid = b.Cid
					and a.Ecodigo = b.Ecodigo
				left outer join CConceptos c
					on b.CCid = c.CCid
					and b.Ecodigo = c.Ecodigo
				inner join ClasificacionItemsProv d
					on c.CCid = d.CCid
					and c.Ecodigo = d.Ecodigo
				inner join SNegocios e
					on d.SNcodigo = e.SNcodigo
					and d.Ecodigo = e.Ecodigo
			where 	a.Ecodigo = #Session.Ecodigo#
					and a.Cid in (  select x.Cid
									from DSolicitudCompraCM x
										inner join CMLineasProceso  y
											on x.DSlinea = y.DSlinea
											and y.CMPid = #Session.Compras.ProcesoCompra.CMPid#  
									where  x.Ecodigo = #Session.Ecodigo#
											and x.Cid is not null
											and x.ESidsolicitud in(#solicitudes#))		
											
		union									
			select 
				coalesce((select max(pu.fechaalta) from CMProveedoresProceso pu where pu.SNcodigo = e.SNcodigo),
				(select min(p.SNFecha) from SNegocios p where p.SNcodigo = e.SNcodigo)) as fechaalta,	
					d.SNcodigo as checked, 
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as inactive, 
					d.SNcodigo,
					e.SNnumero,
					e.SNnombre
			from DSolicitudCompraCM a
				left outer join AClasificacion b
						on b.Ecodigo = a.Ecodigo
						and b.ACid = a.ACid
						and b.ACcodigo = a.ACcodigo
					
					inner join ClasificacionItemsProv d
						on b.AClaId = d.AClaId
						and b.Ecodigo = d.Ecodigo
						
					inner join SNegocios e
						on d.SNcodigo = e.SNcodigo
						and d.Ecodigo = e.Ecodigo
							
							
			where 	a.Ecodigo = #Session.Ecodigo#
					and a.ACid in (  select x.ACid
									from DSolicitudCompraCM x
										inner join CMLineasProceso  y
											on x.DSlinea = y.DSlinea
											and y.CMPid = #Session.Compras.ProcesoCompra.CMPid#  
									where  x.Ecodigo = #Session.Ecodigo#
											and x.ACid is not null
											and x.ESidsolicitud in(#solicitudes#))		

				order by fechaalta asc
	</cfquery>
<cfelse>
	<cfquery name="rsProveedores" datasource="#Session.DSN#">
		select 	a.SNcodigo, 
				a.SNnumero, 
				a.SNnombre
		from SNegocios a
		where a.Ecodigo = #Session.Ecodigo#
		and a.SNtiposocio <> 'C'
		<cfif isdefined("Form.txt_numero") and Len(Trim(Form.txt_numero))>
			and upper(a.SNnumero) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(Form.txt_numero)#%">
			<!---<cfset filtro = filtro & " and upper(a.ETdescripcion) like '%" & Ucase(form.ETdescripcion_F) & "%'">---->
		</cfif>
		<cfif isdefined("Form.txt_nombre") and Len(Trim(Form.txt_nombre))>
			and upper(a.SNnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(Form.txt_nombre)#%">
		</cfif>
		order by SNnumero
	</cfquery>
</cfif>

<cfset iCount = 1>
<script language="javascript" type="text/javascript">
	function limpiarProveedores() {
		if (document.form1.chk.value) {
			document.form1.chk.checked = false;
		} else {
			for (var i=0; i<document.form1.chk.length; i++) {
				document.form1.chk[i].checked = false;
			}
		}				
		<cfif LvarEstadoProceso EQ 0>
			document.form1.proveedores.value = 'todos';			
			document.form1.submit();
		</cfif>			
	}
	
	function checkProveedores() {
		var todos = true;
		if (document.form1.chk.value) {
			todos = !document.form1.chk.checked;
		} /*else {
			for (var i=0; i<document.form1.chk.length; i++) {
				if (document.form1.chk[i].checked) 
				{					
					document.form1.selecionados.value = 1;
					//todos = false; break;
				}
			}
		}*/
		if (todos) {			
			document.form1.selProveedores[0].checked = true;
		} else {			
			document.form1.selProveedores[1].checked = true;
		}
		return true;
	}
	
	function collectData() {
		var prov = "";
		if (document.form1.chk.value) {
			prov = document.form1.chk.value;
		} else {
			for (var i=0; i<document.form1.chk.length; i++) {
				prov = prov + ((prov != "") ? "," : "") + document.form1.chk[i].value;
			}
		}
		document.form1.prov.value = prov;
	}
	
	function FuncSeleccionados(){
		<cfif LvarEstadoProceso EQ 0>
			document.form1.proveedores.value = '';
			document.form1.submit();
		</cfif>
	}
	
	
	function fnSelecionarSugeridos(c,cant,selecionados){
		if(! cant || selecionados)
			cant = document.form1.chk.length;
		if (document.form1.chk != null) { //existe?
			if (document.form1.chk.value != null) {// solo un check
				if (c.checked) 
					document.form1.chk.checked = true; 						
				else
					document.form1.chk.checked = false;
			}else { 
				if (c.checked) {			
					for(counter = 0; counter < cant && counter < document.form1.chk.length; counter++){	
						if (! document.form1.chk[counter].disabled)
							LvarEstado = true; 
						else{ 
							LvarEstado = false;
							cant +=( cant + 1 < document.form1.chk.length ? 1 : 0);
						}
						if ((!document.form1.chk[counter].checked) && LvarEstado == true){
							if(selecionados){
								ids = selecionados.split(',');
								for(i=0;i < ids.length;i++) {
									if(document.form1.chk[counter].value == ids[i]){
										document.form1.chk[counter].checked = true;
										break;
									}
								}
							}else 
								document.form1.chk[counter].checked = true; 
						}
					} 
				}
			}
		}
	}
</script>


<form name="form1" method="post" action="<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>">
	<input type="hidden" name="opt" value="">
	<input type="hidden" name="prov" value="">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="2" align="center">
			<fieldset>
				<cfoutput>
				<table width="90%" border="0" cellpadding="0" cellspacing="0">
				  <input name="proveedores" type="hidden" value="<cfif isdefined("form.proveedores")>#form.proveedores#<cfelse>1</cfif>">					
					<cfset vnSeleccionados = 0><!---- Variable para pintar la primera vez el check de solo los seleccionados en true----->
					<cfif rsProv.RecordCount EQ 0>
						<cfset vnSeleccionados = 1>
					</cfif>
					<cfif isdefined("form.proveedores") and form.proveedores EQ 'todos'>
						<cfset rsProveedoresSeleccionados.cant = 0>
						<cfset vnSeleccionados = 1>	
						<cfif LvarEstadoProceso EQ 0>
							<cfset vnPrimeravez = 1>
						</cfif>
					</cfif>	
				  <tr>
					<td width="5%" align="right">
						<input name="selProveedores" type="radio" value="todos" align="absmiddle" style="border: none; " <cfif (modo EQ 'ALTA') and (rsProveedoresSeleccionados.cant EQ 0) or(vnSeleccionados NEQ 0)>checked</cfif> onClick="javascript: limpiarProveedores();" <cfif modo EQ "CAMBIO" and rsProveedoresPublicados.cant GT 0> disabled</cfif>>
					</td>
					<td> Invitar a <strong>TODOS</strong> los proveedores a participar en el proceso de compra </td>
				  </tr>
				  <tr>					
					<td align="right">
						<input name="selProveedores" type="radio" value="" align="absmiddle" style="border: none; "<cfif (modo EQ 'CAMBIO' and rsProveedoresSeleccionados.cant GT 0) or (isdefined("form.proveedores") and form.proveedores EQ '') or (vnSeleccionados EQ 0)>checked</cfif> onClick="javascript: FuncSeleccionados();">
					</td>
					<td>Invitar a los proveedores <strong>SELECCIONADOS</strong> abajo a participar en el proceso de compra </td>
				  </tr>
				</table>
			</fieldset><br>
			<table width="90%"  border="0" cellspacing="0" cellpadding="0" align="center">
			  <tr>
			    <td>
				
				  <table width="100%"  border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
                      <tr>
                        <td class="fileLabel" align="right">N&uacute;mero:</td>
                        <td>
							<input type="text" name="txt_numero" size="20" value="<cfif isdefined("Form.txt_numero")>#Form.txt_numero#</cfif>">
						</td>
                        <td class="fileLabel" align="right">Nombre:</td>
                        <td>
							<input type="text" name="txt_nombre" size="40" value="<cfif isdefined("Form.txt_nombre")>#Form.txt_nombre#</cfif>">
						</td>
                        <td align="center">
							<input type="submit" name="btnBuscar" class="btnFiltrar" value="Buscar">
						</td>
                      </tr>
                    </table>
				</cfoutput>
				</td>
		      </tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr align="center">
					<td colspan="2">
						<input type="submit" name="btnGuardarEsp"  class="btnGuardar" value="Guardar" onClick="javascript: collectData(); funcSiguiente(); "> <!--- onMouseOver="javascript: this.className='botonDown2';" onMouseOut="javascript: this.className='botonUp2';" --->
						<input type="submit" name="btnGuardar"     class="btnGuardar" value="Guardar y Continuar >>" onClick="javascript: collectData(); funcSiguiente(); "> <!--- onMouseOver="javascript: this.className='botonDown2';" onMouseOut="javascript: this.className='botonUp2';" --->
					</td>
			    </tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
			  <tr>
			  <cfif rsProveedoresSeleccionados.cant EQ  0>
				<td>
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pLista">
			  <cfif (isdefined("form.selProveedores") and form.selProveedores EQ '') and (vnSeleccionados NEQ 1) and  (rsProveedoresSeleccionados.cant EQ 0) and (LvarEstadoProceso EQ 0)>
						<cfinvokeargument name="query" 				value="#rsProv#"/>
					<cfelseif modo EQ 'CAMBIO'> 										
						<cfinvokeargument name="query" 				value="#rsProveedores#"/>					
					</cfif>
						<cfinvokeargument name="desplegar" 			value="SNnumero, SNnombre"/>
						<cfinvokeargument name="etiquetas" 			value="N&uacute;mero, Nombre"/>
						<cfinvokeargument name="formatos" 			value="V, V"/>
						<cfinvokeargument name="align" 				value="left, left"/>
						<cfinvokeargument name="ajustar" 			value="N"/>
						<cfinvokeargument name="irA" 				value="#GetFileFromPath(GetTemplatePath())#"/>
						<cfinvokeargument name="keys" 				value="SNcodigo"/>
						<cfinvokeargument name="inactivecol" 		value="inactive"/>
						<cfinvokeargument name="MaxRows" 			value="15"/>
						<cfinvokeargument name="incluyeForm" 		value="false"/>
						<cfinvokeargument name="formName" 			value="form2"/>
						<cfinvokeargument name="checkboxes" 		value="S"/>
						<cfinvokeargument name="PageIndex" 			value="3"/>
						<cfinvokeargument name="showLink" 			value="false"/>
						<cfinvokeargument name="checkbox_function" 	value="checkProveedores();"/>
						<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
					</cfinvoke>
				</td>
				<cfelse>
				<td>
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pLista">
		      <cfif (isdefined("form.selProveedores") and form.selProveedores EQ '') and (vnSeleccionados NEQ 1) and  (rsProveedoresSeleccionados.cant EQ 0) and (LvarEstadoProceso EQ 0)>
						<cfinvokeargument name="query" 				value="#rsProv#"/>
					  <cfelseif modo EQ 'CAMBIO'> 										
						<cfinvokeargument name="query" 				value="#rsProveedores#"/>					
					  </cfif>
						<cfinvokeargument name="desplegar" 			value="SNnumero, SNnombre"/>
						<cfinvokeargument name="etiquetas" 			value="N&uacute;mero, Nombre"/>
						<cfinvokeargument name="formatos" 			value="V, V"/>
						<cfinvokeargument name="align" 				value="left, left"/>
						<cfinvokeargument name="ajustar" 			value="N"/>
						<cfinvokeargument name="irA" 				value="#GetFileFromPath(GetTemplatePath())#"/>
						<cfinvokeargument name="keys" 				value="SNcodigo"/>
						<cfinvokeargument name="checkedcol" 		value="checked"/>
						<cfinvokeargument name="inactivecol" 		value="inactive"/>
						<cfinvokeargument name="MaxRows" 			value="15"/>
						<cfinvokeargument name="incluyeForm" 		value="false"/>
						<cfinvokeargument name="formName" 			value="form2"/>
						<cfinvokeargument name="checkboxes" 		value="S"/>
						<cfinvokeargument name="PageIndex" 			value="3"/>
						<cfinvokeargument name="showLink" 			value="false"/>
						<cfinvokeargument name="checkbox_function" 	value="checkProveedores();"/>
						<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
					</cfinvoke>
				</td>
				</cfif>
			  </tr>
			</table>
		</td>
	</tr>
	</table>
</form>

<cfif rsProveedoresSeleccionados.cant EQ  0>
  <script language="javascript1.2" type="text/javascript">
        fnSelecionarSugeridos(document.form1.selProveedores[1],<cfoutput>#LvarSugeridos#</cfoutput><cfif isdefined('Form.chk') and len(trim(Form.chk))>,'<cfoutput>#Form.chk#</cfoutput>'</cfif>);
    </script>
</cfif>