
<!---►►JS◄◄--->
<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>

<!---►►Filtros◄◄--->
<CF_NAVEGACION NAME="ECid">
<CF_NAVEGACION NAME="ESidsolicitud">
<!--- <cf_dump var=#form#> --->
<cfif isdefined("url.Consecutivo_f")      and len(url.Consecutivo_f)      and not isdefined("form.Consecutivo_f")><cfset form.Consecutivo_f = url.Consecutivo_f></cfif>
<cfif isdefined("url.CMTSdescripcion") and len(url.CMTSdescripcion) and not isdefined("form.CMTSdescripcion")><cfset form.CMTSdescripcion = url.CMTSdescripcion></cfif>
<cfif isdefined("url.Ccodigo") 		   and len(url.Ccodigo)         and not isdefined("form.Ccodigo")><cfset form.Ccodigo = url.Ccodigo></cfif>
<cfif isdefined("url.CFcodigo")        and len(url.CFcodigo)        and not isdefined("form.CFcodigo")><cfset form.CFcodigo = url.CFcodigo></cfif>
<cfif isdefined("url.Ecodigo")        and len(url.Ecodigo)        and not isdefined("form.Ecodigo")><cfset form.Ecodigo= url.Ecodigo></cfif>

<cfparam name="form.Ecodigo" default="#session.Ecodigo#">
<cfparam name="form.Consecutivo_f" default="">
<cfparam name="form.ECid" 		default="0">
<cfset navegacion = "">
<cfif isdefined("form.ECid") and len(trim(form.ECid)) >
	<cfset navegacion = navegacion & "&ECid=#form.ECid#">
</cfif>

<!---►►Categorias◄◄--->
<cfquery name="rsCategorias" datasource="#session.DSN#" >
	select ACcodigo, ACdescripcion
	from ACategoria
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
</cfquery>

<!---►►Clasificacion◄◄--->
<cfquery name="rsClasificacion" datasource="#Session.DSN#">
	select ACid, ACdescripcion, ACcodigo
	from AClasificacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
	order by ACcodigo, ACdescripcion
</cfquery>

<!---►►Socio Negocios◄◄--->
<cfquery name="rsSN" datasource="#Session.DSN#">
  select e.SNcodigo, Mcodigo
	from ESolicitudCompraCM e
   where e.Ecodigo   	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
	 and e.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ESidsolicitud#">
</cfquery>

<cfquery name="rsProveedor" datasource="#Session.DSN#">
  select e.SNnumero, SNnombre
	from SNegocios e
   where e.Ecodigo   	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
	 and e.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSN.SNcodigo#">
</cfquery>
<!--- Contrato de Compra --->
<cf_dbfunction name="op_concat" returnvariable="_Cat">
<cfquery name="rsListaItems" datasource="#Session.DSN#">
	select
		  a.Ecodigo, a.ECid, a.Consecutivo, a.ECfalta, b.DCdescripcion, <!--- e.DStotallinest,---> b.DClinea,  #form.ECid# as llave, b.DCtipoitem,
		  'Contrato: '#_Cat# <cf_dbfunction name="to_char" args="a.Consecutivo"> #_Cat# ' - '#_Cat#
		   a.ECdesc as corte,
		   '<label style="font-weight:normal" title="'#_Cat# a.ECdesc #_Cat#'">' #_Cat# <cf_dbfunction name='sPart' args='a.ECdesc|1|50' delimiters='|'> #_Cat# case when <cf_dbfunction name="length" args="a.ECdesc"> > 50 then '...' else '' end as ECdesc,
			case b.DCtipoitem
				when 'A' then 'Articulo'
				when 'S' then 'Servicio'
				when 'F' then 'Activo'
				else ''
			end as TipoItem,
			case b.DCtipoitem
				when 'A' then (select Acodigo 	from Articulos 		x where x.Ecodigo = b.Ecodigo and x.Aid = b.Aid)
				when 'S' then (select Ccodigo 	from Conceptos 		x where x.Ecodigo = b.Ecodigo and x.Cid = b.Cid)
				when 'F' then (select y.ACcodigodesc#_cat#'-'#_cat#x.ACcodigodesc 	from AClasificacion x  inner join ACategoria y on y.Ecodigo=x.Ecodigo and y.ACcodigo=x.ACcodigo where x.Ecodigo = b.Ecodigo and x.ACcodigo = b.ACcodigo and x.ACid = b.ACid)
				else ''
			end as CodigoItem
		from EcontratosCM a
			 inner join DContratosCM b
			 	ON a.ECid = b.ECid
			 	AND a.Ecodigo = b.Ecodigo
			 	and cast(b.ECid as varchar) + '-' + cast(b.DClinea as varchar) not in (select cast(ECid as varchar) + '-' + cast(DClinea as varchar) from DSolicitudCompraCM where ESidsolicitud = #form.ESidsolicitud# and Ecodigo = #session.Ecodigo#)
		where 1=1
		  and ECestado = 2
		  and DCcantcontrato - DCcantsurtida > 0
		  and b.Mcodigo = #rsSN.Mcodigo#
		  and #session.Usucodigo# in (select Usucodigo from CMContratoNotifica where Ecodigo = #session.Ecodigo# and ECid = a.Ecid)


		<cfif isdefined("form.TipoItem") and form.TipoItem NEQ ''>
			and b.DCtipoitem = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TipoItem#">
		</cfif>

		<cfif isdefined("form.ECdesc") and len(trim(form.ECdesc)) >
			and upper(ECdesc) like  upper('%#form.ECdesc#%')
		</cfif>

		<!---<cfif isdefined("form.ECid") and len(trim(form.ECid)) >
			and a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
		</cfif> --->

		<cfif isdefined('form.Consecutivo_f') and Len(Trim(form.Consecutivo_f))>
			and a.Consecutivo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Consecutivo_f#">
		</cfif>





		<cfif isdefined("form.Aid") and len(trim(form.Aid)) >
			and b.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
		</cfif>

		<cfif isdefined("form.ACcodigo") and len(trim(form.ACcodigo)) >
			and b.ACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACcodigo#">
		</cfif>

		<cfif isdefined("form.ACid") and len(trim(form.ACid)) >
			and b.ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACid#">
		</cfif>

		<!---<cfif isdefined("form.CFcodigo") and len(trim(form.CFcodigo)) >
			and upper(c.CFcodigo) like  upper('%#form.CFcodigo#%')
		</cfif>

	   <cfif isdefined("form.NAP") and len(trim(form.NAP)) >
			and a.NAP= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NAP#">
	   </cfif> --->
	   <!---Valida que no este en una OC --->
		 <!--- and (
			  select count(1)
				from EOrdenCM ee
				   inner join DOrdenCM dd
						  on dd.ECid = ee.ECid
			  where ee.Ecodigo = a.Ecodigo
			   and ee.EOestado between 0 and 9
			   and dd.DSlinea = e.DSlinea
			) = 0 --->
	   <!---Valida tenga el mismo proveedor o ninguno OC --->
	   <cfif rsSN.SNcodigo NEQ "">
		 and coalesce(a.SNcodigo,#rsSN.SNcodigo#) = #rsSN.SNcodigo#
	   </cfif>
		<!---Verifica que no exista la linea en seleccion de proveedores y que no haya sido aplicada ahi---->
				<!--- and not exists(select 1
								from DSProvLineasContrato z
								where z.DSlinea = e.DSlinea
									and z.Ecodigo = e.Ecodigo
									and z.Estado = 0
								) --->
		<!-----Verificar que la línea no este en una requisición------>
				<!--- and not exists (select 1
								from DRequisicion p
								where p.DSlinea = e.DSlinea
								) --->
		<!--- Chequea que sean líneas que no pertenezcan a otro Proceso de Compra, con excepción de los Procesos Cerrados --->
				<!--- and not exists (
					select 1
					from CMLineasProceso x
						inner join CMProcesoCompra y
						on y.CMPid = x.CMPid
						and y.CMPestado NOT IN ( 50,85) <!---Excluye aquellos procesos que ya estan en Orden de compra o que fueron Anulados(Los rechazados por el solicitante????)--->
					where x.ESidsolicitud = e.ESidsolicitud
					and x.DSlinea = e.DSlinea
				<cfif isdefined('modo') and modo EQ "CAMBIO">
					and x.CMPid <> #Session.Compras.ProcesoCompra.CMPid#
				</cfif>
				) --->

		<!--- Chequea que sean líneas que no pertenezcan a ninguna Orden de Compra y que no este cancelada, para evitar mostrar las líneas que hayan sido generadas por Contrato --->
				<!--- and not exists (
					select 1
					from DOrdenCM x
						inner join EOrdenCM y
						on y.ECid = x.ECid
						and y.EOestado <> 60 <!---Cancelada --->
						and y.EOestado <> 55 <!---Cancelada Parcialmente Surtida --->
						and y.EOestado <> 10 <!---Aplicada --->
						and y.EOestado <> 70 <!---Anulada--->
					where x.ESidsolicitud = e.ESidsolicitud
					and x.DSlinea = e.DSlinea
				)
				<cfif isdefined('ProcesoPublicado') and ProcesoPublicado> --->
		<!--- Muestra solo las líneas para el Proceso de Compra cuando éste ya ha sido publicado --->
					<!--- and exists (
						select 1
						from CMLineasProceso x
						where
						<!--- x.CMPid = #Session.Compras.ProcesoCompra.CMPid# --->
						and x.ESidsolicitud = e.ESidsolicitud
						and x.DSlinea = e.DSlinea
					)
				</cfif>--->
		order by a.Consecutivo, b.DClinea
</cfquery>
<!--- <cf_dump var=#rsListaItems#> --->
<cfoutput>
	<form style="margin: 0" action="popUp-contratoSolicitud.cfm?Ecodigo=<cfoutput>#form.Ecodigo#</cfoutput>" name="fsolicitud" id="fsolicitud" method="post">
		<!--- ID --->
		<input type="hidden" value="#form.ESidsolicitud#" name="ESidsolicitud">
		<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
			<tr>
				<!--- numero solicitud --->
				<td class="fileLabel" nowrap width="8%" align="right"><label for="Consecutivo">Contrato:</label></td>
				<td nowrap width="31%">
				   <cf_inputNumber comas="false" name="Consecutivo_f" Enteros="6" value="#form.Consecutivo_f#" style="text-transform: uppercase;" tabindex="1">
				</td>
				<!--- Descripción --->
				<td class="fileLabel" nowrap width="9%" align="right">Descripci&oacute;n:</td>
				<td nowrap width="25%"><input type="text" name="ECdesc" size="20" maxlength="100" value="<cfif isdefined('form.ECdesc')>#form.ECdesc#</cfif>" style="text-transform: uppercase;" tabindex="1">
				</td>

				<td colspan="2">
				</td>
			</tr>

			<tr>
				<!--- Centro Funcional --->
				<td class="fileLabel" align="right" nowrap>Proveedor:</td>
				<td nowrap width="25%"> <strong>#rsProveedor.SNnumero# - #rsProveedor.SNnombre#</strong>
				</td>
			</tr>
			<tr>
				<!--- tipo --->
				<td class="fileLabel" nowrap width="9%" align="right">Tipo:</td>
				<td width="27%" rowspan="1" align="left" valign="center">
					<select name="TipoItem" tabindex="1" value ="this.value"  onchange="this.form.submit()">
						<option value=""<cfif not isdefined("form.TipoItem") OR form.TipoItem EQ "">selected</cfif>>Todos</option></option>
						<option value="A"<cfif isdefined("Form.TipoItem") and (Form.TipoItem eq "A")>selected</cfif>>Art&iacute;culo</option>
						<option value="S"<cfif isdefined("Form.TipoItem") and (Form.TipoItem eq "S")>selected</cfif>>Servicio</option>
						<option value="F"<cfif isdefined("Form.TipoItem") and (Form.TipoItem eq "F")>selected</cfif>>Activo</option>
					</select>
				</td>
				<td colspan="2" width="27%" rowspan="1" align="center" valign="center"><input type="submit" class="btnFiltrar" name="btnFiltro" value="Filtrar"></td>
			</tr>
			<tr>
				<cfif isdefined("form.TipoItem") and form.TipoItem EQ 'A'>
					<td class="fileLabel" align="right" nowrap>Art&iacute;culo:&nbsp;</td>
					<td>
						<input type="hidden" name="Almacen" value="" />
						<cf_sifarticulos form="fsolicitud" id="Aid" almacen="Almacen" tabindex="2">
					</td>
				</cfif>
				<cfif isdefined("form.TipoItem") and form.TipoItem EQ 'F'>
				   <td class="fileLabel" align="right" nowrap>Categor&iacute;a:</td>
					<td nowrap width="25%">
						 <select name="ACcodigo" onChange="javascript:cambiar_categoria();" tabindex="2" >
							<cfloop query="rsCategorias">
								<option value="#rsCategorias.ACcodigo#">#rsCategorias.ACdescripcion#</option>
							</cfloop>
						  </select>
					</td>

					<td class="fileLabel" align="right" nowrap>Clasificaci&oacute;n:</td>
					<td nowrap width="25%">
						<select name="ACid" tabindex="2">
						</select>
					</td>
					<td colspan="2">
					</td>
				</cfif>

				<cfif isdefined("form.TipoItem") and form.TipoItem EQ 'S'>
					<td class="fileLabel" nowrap width="9%" align="right">Servicio:</td>
					<td nowrap width="25%">
						<cf_conlis
							Campos="Cid,Ccodigo,Cdescripcion"
							tabindex="6"
							Desplegables="N,S,S"
							Modificables="N,S,N"
							Size="0,15,35"
							Title="Lista Conceptos de Servicios"
							Tabla="Conceptos c"
							Columnas="Cid,Ccodigo,Cdescripcion"
							Filtro="Ecodigo = #form.Ecodigo# order by Ccodigo,Cdescripcion"
							Desplegar="Ccodigo,Cdescripcion"
							Etiquetas="C&oacute;digo,Descripci&oacute;n"
							filtrar_por="Ccodigo,Cdescripcion"
							Formatos="S,S"
							form="fsolicitud"
							Align="left,left"
							Asignar="Cid,Ccodigo,Cdescripcion"
							Asignarformatos="I,S,S"/>
					</td>
				</cfif>
			</tr>
		</table>
	</form>
</cfoutput>
<!---Lista de Items--->
<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="subTitulo"><font size="2">Lista de Detalles</font></td>
	</tr>
</table>

<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
					<cfinvokeargument name="query" 				value="#rsListaItems#">
					<cfinvokeargument name="desplegar" 			value="ECfalta, DCtipoitem, CodigoItem, DCdescripcion">
					<cfinvokeargument name="etiquetas" 			value="Fecha, Tipo, Item, Descripcion">
					<cfinvokeargument name="formatos" 			value="D,V,V,V">
					<cfinvokeargument name="align" 				value="left,left,left,left">
					<cfinvokeargument name="ajustar" 			value="S">
					<cfinvokeargument name="showEmptyListMsg" 	value="true">
					<cfinvokeargument name="irA" 				value="popUp-contratosolicitud-SQL.cfm?ESidsolicitud=#form.ESidsolicitud#">
					<cfinvokeargument name="formName" 			value="form3">
					<cfinvokeargument name="maxrows" 			value="50"/>
					<!--- <cfinvokeargument name="keys" 				value="DClinea,llave,Consecutivo"> --->
					<!--- <cfinvokeargument name="funcion" 			value="ProcesarLinea"> --->
					<!--- <cfinvokeargument name="fparams" 			value="DClinea"> --->
					<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
					<cfinvokeargument name="usaAjax" 			value="true"/>
					<cfinvokeargument name="conexion" 			value="#session.dsn#"/>
					<cfinvokeargument name="Cortes" 			value="corte"/>
					<cfinvokeargument name="chkcortes" 			value="S"/>
					<cfinvokeargument name="keycorte" 			value="Consecutivo"/>
				 <cfif isdefined ("rsListaItems") and rsListaItems.recordcount GT 0>
					<cfinvokeargument name="botones" 			value="Agregar"/>
				</cfif>
			</cfinvoke>
		</td>
	</tr>
</table>
<hr width="99%" align="center">
<script language='javascript' type='text/JavaScript' >
	function ProcesarLinea(Linea){
		return false;
	}
	function cambiar_categoria() {
		var categoria = document.fsolicitud.ACcodigo.value;
		var combo = document.fsolicitud.ACid;
		var cont = 0;
		combo.length=0;
		<cfoutput query="rsClasificacion">
			if (#Trim(rsClasificacion.ACcodigo)#==trim(categoria))
			{
				combo.length=cont+1;
				combo.options[cont].value='#rsClasificacion.ACid#';
				combo.options[cont].text='#rsClasificacion.ACdescripcion#';
				cont++;
			};
		</cfoutput>
	}
</script>

