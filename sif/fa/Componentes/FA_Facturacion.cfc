<!---
	--- FA_Facturacion
	--- --------------
	---
	--- author: martin
	--- date:   8/11/16
	--->
<cfcomponent accessors="true" output="false" persistent="false">


	<cffunction name="getDireccionesSocio" access="remote" returntype="array" returnformat="json" output="false">
		<!--- Define arguments. --->
		<cfargument name="Snegocio" type="string" />

		<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
		<cfquery name="direcciones" datasource="#session.DSN#">
			select b.id_direccion, coalesce(c.direccion1,'') #_Cat# ' / ' #_Cat# coalesce(c.direccion2,'') as texto_direccion
			from SNegocios a
				inner join SNDirecciones b
					on a.SNid = b.SNid
				inner join DireccionesSIF c
					on c.id_direccion = b.id_direccion
			where a.Ecodigo = #Session.Ecodigo#
			  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Snegocio#">
		</cfquery>

		<cfreturn QueryToArray(direcciones)>
	</cffunction>


	<cffunction name="fnValidaObjImpuesto" access="remote" returntype="array" returnformat="json" output="false">
		<cfargument name="Icodigo" type="string" />
		<cfargument name="DSN"     type="string" required="false" default="#session.dsn#">
		<cfargument name="Ecodigo" type="numeric" required="false" default="#session.Ecodigo#">

		<cfquery name="rsIvaImp" datasource="#Arguments.DSN#">
			select Icreditofiscal 
			from Impuestos 
			where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Icodigo#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		</cfquery>
		
		<cfif rsIvaImp.Icreditofiscal eq 0>
			<cfset codigoImp = "01">
		<cfelseif rsIvaImp.Icreditofiscal eq 1>
			<cfset codigoImp = "02">
		<cfelse>
			<cfset codigoImp = "03">
		</cfif>

		<cfquery name="rsObjetoImp" datasource="#session.DSN#">
			select IdObjImp, CSATcodigo, CSATdescripcion
			from CSATObjImpuesto
			where CSATcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#codigoImp#">
		</cfquery>
		
		<cfreturn QueryToArray(rsObjetoImp)>
	</cffunction>

	<cffunction name="getDetallesPrefactura" access="remote" output="true">
		<cfargument name="IDpreFactura" type="numeric" />

		<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Tipo" default="Tipo" returnvariable="LB_Tipo" xmlfile="FAprefacturaDet-lista.xml">
		<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile="FAprefacturaDet-lista.xml">
		<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DescripcionAlterna" default="Descripcion Alterna" returnvariable="LB_DescripcionAlterna" xmlfile="FAprefacturaDet-lista.xml">
		<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PrecioUnitario" default="Precio Unitario" returnvariable="LB_PrecioUnitario" xmlfile="FAprefacturaDet-lista.xml">
		<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descuento" default="Descuento" returnvariable="LB_Descuento" xmlfile="FAprefacturaDet-lista.xml">
		<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_IEPS" default="IEPS" returnvariable="LB_IEPS" xmlfile="FAprefacturaDet-lista.xml">
		<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Total" default="Total" returnvariable="LB_Total" xmlfile="FAprefacturaDet-lista.xml">

		<!--- Filtro para la lista
		<cfinclude template="cotizaciones-filtro.cfm">--->
		<cfquery name="rsDetCotiz" datasource="#session.dsn#">
			Select 	Linea,
					cd.IDpreFactura,
					ce.FAX04CVD,
					case TipoLinea
						when 'A' then 'Articulo'
						when 'S' then 'Servicio'
					end TipoLinea,
					case TipoLinea
						when 'A' then cd.Aid
						when 'S' then cd.Cid
					end codArtServ,
					Descripcion,
		            Descripcion_Alt,
					Cantidad,
					PrecioUnitario,
					FAMontoIEPSLinea,
					cd.DescuentoLinea,
					TotalLinea
			from FAPreFacturaD cd
				inner join FAPreFacturaE ce
					on ce.Ecodigo=cd.Ecodigo
						and ce.IDpreFactura=cd.IDpreFactura

				left outer join Articulos a
					on a.Ecodigo=cd.Ecodigo
						and a.Aid=cd.Aid

				left outer join Conceptos c
					on c.Ecodigo=cd.Ecodigo
						and c.Cid=cd.Cid
			where cd.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and cd.IDpreFactura=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDpreFactura#">
		</cfquery>

		<script type="text/javascript" language="JavaScript" src="/cfmx/commons/js/pLista1.js"></script>

		<table width="100%">
			<tr>
				<td>
				<form action="FAprefactura.cfm" method="post" name="sql">
					<input name="IDpreFactura" id="IDpreFactura" type="hidden" value="">
					<input name="Linea" type="hidden" value="">
				</form>
				<div id="div_Plista">

				<table class="PlistaTable" align="center" border="0" cellspacing="0" cellpadding="0" width="100%">
					<thead>
						<tr>
							<th class="tituloListas" align="left" width="18" height="17" nowrap></th>
							<th class="tituloListas" align="left" valign="bottom"> <strong  > #LB_Tipo#</strong> </th>
							<th class="tituloListas" align="left" valign="bottom"> <strong  > #LB_Descripcion#</strong> </th>
							<th class="tituloListas" align="left" valign="bottom"> <strong  > #LB_DescripcionAlterna#</strong> </th>
							<th class="tituloListas" align="right" valign="bottom"> <strong  > #LB_PrecioUnitario#</strong> </th>
							<th class="tituloListas" align="right" valign="bottom"> <strong  > #LB_Descuento#</strong> </th>
							<th class="tituloListas" align="right" valign="bottom"> <strong  > #LB_IEPS#</strong> </th>
							<th class="tituloListas" align="right" valign="bottom"> <strong  > #LB_Total#</strong> </th>
						</tr>
					</thead>
					<cfset currRow = 1>
					<cfset strCLass = "listaNon">
					<cfloop query="rsDetCotiz">
						<cfoutput>
							<cfif currRow mod 2 eq 0>
								<cfset strCLass = "listaPar">
							<cfelse>
								<cfset strCLass = "listaNon">
							</cfif>
							<tr class="#strCLass#" onmouseover="this.className='#strCLass#Sel';" onmouseout="this.className='#strCLass#';">
								<td align="left" width="18" height="18" nowrap onclick="javascript: return funcProcesar('#rsDetCotiz.IDpreFactura#','#rsDetCotiz.Linea#');"> </td>
								<td align="left" class="pStyle_TipoLinea" nowrap style="padding-right: 3px; cursor: pointer; " onclick="javascript: return funcProcesar('#rsDetCotiz.IDpreFactura#','#rsDetCotiz.Linea#');" onmouseover="javascript:  window.status = '';  return true;" onmouseout="javascript:  window.status = '';  return true;">#rsDetCotiz.TipoLinea#&nbsp;</td>
								<td align="left" class="pStyle_Descripcion" nowrap style="padding-right: 3px; cursor: pointer; " onclick="javascript: return funcProcesar('#rsDetCotiz.IDpreFactura#','#rsDetCotiz.Linea#');" onmouseover="javascript:  window.status = '';  return true;" onmouseout="javascript:  window.status = '';  return true;">#rsDetCotiz.Descripcion#&nbsp;</td>
								<td align="left" class="pStyle_Descripcion_Alt" nowrap style="padding-right: 3px; cursor: pointer; " onclick="javascript: return funcProcesar('#rsDetCotiz.IDpreFactura#','#rsDetCotiz.Linea#');" onmouseover="javascript:  window.status = '';  return true;" onmouseout="javascript:  window.status = '';  return true;">#rsDetCotiz.Descripcion_Alt#&nbsp;</td>
								<td align="right" class="pStyle_PrecioUnitario" nowrap style="padding-right: 3px; cursor: pointer; " onclick="javascript: return funcProcesar('#rsDetCotiz.IDpreFactura#','#rsDetCotiz.Linea#');" onmouseover="javascript:  window.status = '';  return true;" onmouseout="javascript:  window.status = '';  return true;">#NumberFormat(rsDetCotiz.PrecioUnitario, ",9.00")#</td>
								<td align="right" class="pStyle_DescuentoLinea" nowrap style="padding-right: 3px; cursor: pointer; " onclick="javascript: return funcProcesar('#rsDetCotiz.IDpreFactura#','#rsDetCotiz.Linea#');" onmouseover="javascript:  window.status = '';  return true;" onmouseout="javascript:  window.status = '';  return true;">#NumberFormat(rsDetCotiz.DescuentoLinea, ",9.00")#</td>
								<td align="right" class="pStyle_FAMontoIepsLinea" nowrap style="padding-right: 3px; cursor: pointer; " onclick="javascript: return funcProcesar('#rsDetCotiz.IDpreFactura#','#rsDetCotiz.Linea#');" onmouseover="javascript:  window.status = '';  return true;" onmouseout="javascript:  window.status = '';  return true;">#NumberFormat(rsDetCotiz.FAMontoIepsLinea, ",9.00")#</td>
								<td align="right" class="pStyle_TotalLinea" nowrap style="padding-right: 3px; cursor: pointer; " onclick="javascript: return funcProcesar('#rsDetCotiz.IDpreFactura#','#rsDetCotiz.Linea#');" onmouseover="javascript:  window.status = '';  return true;" onmouseout="javascript:  window.status = '';  return true;">#NumberFormat(rsDetCotiz.TotalLinea, ",9.00")#</td>
							</tr>
						</cfoutput>
						<cfset currRow = currRow + 1>
					</cfloop>
				</table>
				</div>
				</td>
			</tr>
		</table>
	</cffunction>

	<cffunction name="QueryToArray" access="private" returntype="array" output="false">

	    <!--- Define arguments. --->
	    <cfargument name="Data" type="query" required="yes" />

	    <cfscript>
	        // Define the local scope.
	        var LOCAL = StructNew();
	        // Get the column names as an array.
	        LOCAL.Columns = ListToArray( ARGUMENTS.Data.ColumnList );
	        // Create an array that will hold the query equivalent.
	        LOCAL.QueryArray = ArrayNew( 1 );
	        // Loop over the query.
	        for (LOCAL.RowIndex = 1 ; LOCAL.RowIndex LTE ARGUMENTS.Data.RecordCount ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){
	            // Create a row structure.
	            LOCAL.Row = StructNew();
	            // Loop over the columns in this row.
	            for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE ArrayLen( LOCAL.Columns ) ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){
	                // Get a reference to the query column.
	                LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];
	                // Store the query cell value into the struct by key.
	                LOCAL.Row[ LOCAL.ColumnName ] = ARGUMENTS.Data[ LOCAL.ColumnName ][ LOCAL.RowIndex ];
	            }
	            // Add the structure to the query array.
	            ArrayAppend( LOCAL.QueryArray, LOCAL.Row );
	        }
	        // Return the array equivalent.
	        return( LOCAL.QueryArray );
	    </cfscript>
	</cffunction>

	<cffunction name="getTotalesGen" access="remote" output="true">
	<!--- Define arguments. --->
		<cfargument name="IDpreFactura" type="numeric" />

		<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descuento" default="Descuento" returnvariable="LB_Descuento" xmlfile="FAprefacturaDet-form.xml">
		<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Impuesto" default="IVA" returnvariable="LB_Impuesto" xmlfile="FAprefactura-form.xml">
		<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Ieps" default="IEPS" returnvariable="LB_Ieps" xmlfile="FAprefactura-form.xml">
		<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Total" default="Total" returnvariable="LB_Total" xmlfile="FAprefactura-form.xml">
		<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Rets" default="Retenci&oacute;n" returnvariable="LB_Rets" xmlfile="FAprefactura-form.xml">

		<cfif isDefined('IDpreFactura')>
			<cfquery name="rsForm2" datasource="#session.DSN#">
				<!--- Query Modificado para tabla de Facturas --->
		 		Select
					IDpreFactura,
		            <!--- PFDocumento,
					FAX04CVD,
					fac.SNcodigo,
					fac.id_direccion,
					SNnombre,
					Ocodigo,
					fac.Mcodigo,
					PFTcodigo,
					Estatus,
					case Estatus
						when 'R' then '#LB_PAsignar#'
						when 'P' then '#LB_Pendiente#'
						when 'E' then '#LB_Estimada#'
						when 'A' then '#LB_Anulada#'
						when 'T' then '#LB_Terminada#'
						when 'V' then '#LB_Vencida#'
					end EstatusDesc, --->
					coalesce(Descuento,0) as Descuento,
					Impuesto,
					Total,
					<!--- Observaciones,
					TipoCambio,
					fac.BMUsucodigo,
					fechaalta,
					fac.ts_rversion,
					FechaCot,
					vencimiento,
		            NumOrdenCompra,
		            Rcodigo, --->
		            FAieps,
					isnull(fac.MRetencion,0) as MRetencion
				from FAPreFacturaE fac
					inner join SNegocios sn
						on fac.Ecodigo = sn.Ecodigo and fac.SNcodigo=sn.SNcodigo
				where fac.Ecodigo=#Session.Ecodigo#
					and IDpreFactura=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDpreFactura#">
			</cfquery>
				<!--- Armado de struct para devolver en JSON --->
				<!--- <cfset Local.obj = { IDpreFactura = rsForm2.IDpreFactura,
					Descuento = rsForm2.Descuento,
					Impuesto = rsForm2.Impuesto,
					FAieps = rsForm2.FAieps,
					Total = rsForm2.Total
				}> --->
				<fieldset><legend><strong>Totales</strong></legend>
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td align="right"><strong>#LB_Descuento#:&nbsp;</strong></td>
							<td >
								<input name="Descuento2" readonly="true" type="text" id="Descuento2" value="#LSNumberFormat(rsForm2.Descuento,',9.00')#" style="text-align: right" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="13">
							</td>
						</tr>
						<tr>
							<td align="right"><strong>#LB_Impuesto#:&nbsp;</strong></td>
							<td >
								<input name="Impuesto2" readonly="true" type="text" id="Impuesto2" value="#LSNumberFormat(rsForm2.Impuesto,',9.00')#" style="text-align: right" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="16">
							</td>
						</tr>
						<tr>
							<td align="right"><strong>#LB_Ieps#:&nbsp;</strong></td>
							<td >
								<input name="Ieps2" readonly="true" type="text" id="Ieps2" value="#LSNumberFormat(rsForm2.FAieps,',9.00')#" style="text-align: right" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="16">
							</td>
						</tr>
						<tr>
							<td align="right"><strong>#LB_Rets#:&nbsp;</strong></td>
							<td >
								<input name="RetencionE" readonly="true" type="text" id="RetencionE" value="#LSNumberFormat(rsForm2.MRetencion,',9.00')#" style="text-align: right" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="16">
							</td>
						</tr>
						<tr>
							<td align="right"><strong>#LB_Total#:&nbsp;</strong></td>
							<td >
								<input readonly="true" name="Total2" type="text" id="Total2"  value="#LSNumberFormat(rsForm2.Total,',9.00')#" style="text-align: right" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="17">
							</td>
						</tr>
					</table>
				</fieldset>
		</cfif>
	</cffunction>


	<cffunction  name="AplicaPreFactura">
		<cfargument  name="idPrefactura" type="numeric" required="true">
		<cfargument  name="usuario" type="string" required="false" default="#session.usuario#">
		<cfargument  name="usucodigo" type="string" required="false" default="#session.usucodigo#">
		<cfargument  name="dsn" type="string" required="false" default="#session.dsn#">
		<cfargument  name="ecodigo" type="numeric" required="false" default="#session.ecodigo#">

		<!--- Se crea una Tabla temporal para detectar cuantos documentos se crearan --->
		<cf_dbtemp name="PF_aplicacion" returnvariable="PF_aplicacion" datasource="#arguments.dsn#">
			<cf_dbtempcol name="PFTcodigo" type="char(2)">
			<cf_dbtempcol name="SNcodigo" type="int">
			<cf_dbtempcol name="Mcodigo" type="int">
			<cf_dbtempcol name="Ocodigo" type="int">
			<cf_dbtempcol name="IDpreFactura" type="int">
			<cf_dbtempcol name="vencimiento" type="int">
			<cf_dbtempcol name="FechaVen" type="date">
			<cf_dbtempcol name="Rcodigo" type="char(2)">
		</cf_dbtemp>

		<cfset listIDPreF = "#arguments.idPrefactura#">
		<cfset datos = ListToArray(listIDPreF,",")>		
		<cfset limite = ArrayLen(datos)>
		<cfloop from="1" to="#limite#" index="idx">
			<!--- Toma los valores para la Prefactura --->
			<cfquery name="rsPreFact" datasource="#arguments.dsn#">
				select PFTcodigo,SNcodigo,Mcodigo,Ocodigo,IDpreFactura,vencimiento,FechaVen,Rcodigo
				from FAPreFacturaE
				where IDpreFactura = <cfqueryparam value="#datos[idx]#" cfsqltype="cf_sql_integer">
			</cfquery>
			<!--- Inserta valores en tabla Temporal --->
			<cfquery datasource="#arguments.dsn#">
				insert into #PF_aplicacion# (PFTcodigo,SNcodigo,Mcodigo,Ocodigo,IDpreFactura,vencimiento,FechaVen,Rcodigo)
				values
				(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPreFact.PFTcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreFact.SNcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreFact.Mcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreFact.Ocodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreFact.IDpreFactura#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreFact.vencimiento#">,
					<cfqueryparam cfsqltype="cf_sql_date" 	  value="#rsPreFact.FechaVen#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPreFact.Rcodigo#">)
			</cfquery>
		</cfloop>
		<!--- ABCO. Revisa si se aplicaron prefacturas del mismo socio de diferente oficina --->
		<cfquery name="rsVerificaOf" datasource="#arguments.dsn#">
			select SNcodigo, PFTcodigo, Mcodigo, count(Distinct Ocodigo) as Conteo
			from #PF_aplicacion#
			group by SNcodigo, PFTcodigo, Mcodigo
			having count(Distinct Ocodigo) > 1
		</cfquery>
		<cfif rsVerificaOf.recordcount GT 0>
			<cfloop query="rsVerificaOf">
				<!---ABCO/ABG. Se valida si la transacción tiene una oficina definida--->
				<cfquery name="rsOfiTran" datasource="#arguments.dsn#">
					select isnull(Ocodigo,-1) as Ocodigo
					from FAPFTransacciones
					where PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPreFact.PFTcodigo#">
					and	Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and Ocodigo is not null
				</cfquery>
				<cfif rsOfiTran.recordcount EQ 1 and rsOfiTran.Ocodigo NEQ -1>
					<cfquery datasource="#arguments.dsn#">
						update #PF_aplicacion#
						set Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOfiTran.Ocodigo#">
						where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVerificaOf.SNcodigo#">
						and PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsVerificaOf.PFTcodigo#">
						and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVerificaOf.Mcodigo#">
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		<!--- Se toman los valores para saber cuantos documentos se crearan mediante la llave
			PFTcodigo,SNcodigo,Mcodigo --->
		<cfquery name="rsPFllave" datasource="#arguments.dsn#">
			select distinct PFTcodigo,SNcodigo,Mcodigo,Ocodigo,vencimiento,FechaVen,Rcodigo
			from #PF_aplicacion#
		</cfquery>
		<!---ABCO. Tabla de control--->
		<cf_dbtemp name="PF_EControl" returnvariable="PF_EControl" datasource="#arguments.dsn#">
			<cf_dbtempcol name="OImpresionID" type="integer">
			<cf_dbtempcol name="OIDetalle" type="integer">
			<cf_dbtempcol name="ItemTipo" type="char(1)">
			<cf_dbtempcol name="ItemCodigo" type="integer">
			<cf_dbtempcol name="OIDAlmacen" type="integer">
			<cf_dbtempcol name="Ccuenta" type="integer">
			<cf_dbtempcol name="Ecodigo" type="integer">
			<cf_dbtempcol name="Ocodigo" type="integer">
			<cf_dbtempcol name="Icodigo" type="varchar(15)">
			<cf_dbtempcol name="CFid" type="integer">
		</cf_dbtemp>
		
		<cfloop query="rsPFllave">
			<!---ERBG Busca el Centro Funcional y Cuenta Contable Default para el tipo de Transacción que trae la Prefactura INICIA--->
			<cfquery name="rsCFD" datasource="#arguments.DSN#">
				select isnull(CFid,0) CFid from FAPFTransacciones
				where PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
				and Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif len(trim(rsCFD.CFid))>
				<cfset Var_CFid = "#rsCFD.CFid#">
			<cfelse>
				<cfset Var_CFid = 0>
				<!--- <cfabort showerror="La transación de Pre-Factura No tiene Centro Funcional Default"> --->
			</cfif>
		
			<cfquery name="rsCCD" datasource="#arguments.DSN#">
				select isnull(CCuenta,0) CCuenta from FAPFTransacciones
				where PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
				and Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif len(trim(rsCCD.CCuenta))>
				<cfset Var_CcuentaDef = "#rsCCD.CCuenta#">
			<cfelse>
				<cfset Var_CcuentaDef = 0>
				<!--- <cfabort showerror="La transación de Pre-Factura No tiene Cuenta Default"> --->
			</cfif>
			
			<!---ERBG Busca el Centro Funcional Default y Cuenta Contable Default para el tipo de Transacción que trae la Prefactura TERMINA--->
			<!--- Tabla de Documentos a Reversar --->
			<cf_dbtemp name="PF_reversa" returnvariable="PF_reversa" datasource="#arguments.dsn#">
				<cf_dbtempcol name="DdocumentoREF" type="char(20)">
				<cf_dbtempcol name="CCTcodigoREF" type="char(2)">
				<cf_dbtempcol name="CCTcodigoREV" type="char(2)">
				<cf_dbtempcol name="CFid" type="int">
				<cf_dbtempcol name="CCuenta" type="int">
			</cf_dbtemp>
			<cftransaction>
				<!---Validaciones para Aplicar --->
				<!--- La prefactura debe de tener Lineas de Detalle --->
				<cfquery name="rsVerifica" datasource="#arguments.dsn#">
				select IDpreFactura
				from #PF_aplicacion# pf
				where not exists(select 1 from FAPreFacturaD where IDpreFactura = pf.IDpreFactura)
				and pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
				and pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
				and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
				and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
			</cfquery>
				<cfif rsVerifica.recordcount GT 0>
					<cfabort showerror="Pre-Factura No tiene lineas de Detalle">
				</cfif>
				<cfset varGeneraDoc = true>
				<!--- Si la Prefactura es de Tipo Credito y fue aplicada junto con
					Prefacturas de tipo Debito que la referencien no genera Documento solo es aplicada
					como un descuento en la factura --->
				<cfquery name="rsVerifica" datasource="#arguments.dsn#">
				select IDpreFactura
				from #PF_aplicacion# pf
						inner join FAPFTransacciones pft
						on pf.PFTcodigo = pft.PFTcodigo
						and pft.Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
				where pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
				and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
				and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
				and pft.PFTcodigoRef = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
			</cfquery>
				<cfif rsVerifica.recordcount GT 0>
					<cfset varGeneraDoc = false>
				</cfif>
				<cfif varGeneraDoc>
					<!--- valores de catalogo para la transaccion de Prefactura --->
					<cfquery name="rsPFtransaccion" datasource="#arguments.dsn#">
					select *
					from FAPFTransacciones
					where PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
					and Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
					<!--- Cuenta de Cliente para El socio de Negocios --->
					<cfquery name="rsSNcuenta" datasource="#arguments.dsn#">
					select SNnombre,SNcuentacxc
					from SNegocios
					where Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
					and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
				</cfquery>
					<cfif rsSNcuenta.recordcount GT 0 AND rsSNcuenta.SNcuentacxc NEQ "" AND len(ltrim(rsSNcuenta.SNcuentacxc))>
						<cfset varSNcuenta = rsSNcuenta.SNcuentacxc>
					<cfelse>
						<cfabort showerror="Socio de Negocios #rsSNcuenta.SNnombre# no tiene Cuenta Cliente para CxC correctamente definida">
					</cfif>
					<!--- Obtiene valor default para concepto de cobro --->
					<cfquery name="rsTESRPTconcepto" datasource="#arguments.DSN#" >
					select 	min(TESRPTCid) as TESRPTCid
					from TESRPTconcepto
						where CEcodigo = (select CEcodigo from Empresa where Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">)
						and TESRPTCcxc=1
					and TESRPTCdevoluciones=0
				</cfquery>
					<cfif isdefined("rsTESRPTconcepto.TESRPTCid") and rsTESRPTconcepto.TESRPTCid NEQ "">
						<cfset LvarTESRPTCid = rsTESRPTconcepto.TESRPTCid>
					<cfelse>
						<cfabort showerror="No existe ningun Concepto de Cobro definido en el sistema">
					</cfif>
					<!--- Averiguar si el tipo de transaccion es debito o credito --->
					<cfquery name="rsCCTransaccion" datasource="#arguments.DSN#">
					select CCTtipo
					from CCTransacciones
					where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
					and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsPFtransaccion.CCTcodigoRef#">
				</cfquery>
					<cfif rsPFtransaccion.PFTcodigoRef NEQ "" and len(trim(rsPFtransaccion.PFTcodigoRef))>
						<!--- Descuento a aplicar de las Prefacturas de Credito Referenciadas --->
						<cfquery name="rsDescuento" datasource="#arguments.dsn#">
						select isnull(sum(pf.Total),0) as Descuento
						from FAPreFacturaE pf
							inner join #PF_aplicacion# pfa
							on pf.IDpreFactura = pfa.IDpreFactura
							and pf.Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
						where pfa.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.PFTcodigoRef#">
						and pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
						and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
						and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
					</cfquery>
						<cfset varDescuento = rsDescuento.Descuento>
					<cfelse>
						<cfset varDescuento = 0>
					</cfif>
					<!--- Direccion de Facturacion --->
					<cfquery name="rsDireccion" datasource="#arguments.dsn#">
					select min(id_direccion) as Direccion
					from FAPreFacturaE pf
							inner join #PF_aplicacion# pfa
							on pf.IDpreFactura = pfa.IDpreFactura
							and Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
						where pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
						and pfa.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
						and pfa.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
						and pfa.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
				</cfquery>
					<cfset varIDdireccion = rsDireccion.Direccion>
					<!--- Tipo de Cambio --->
					<cfquery name="rsMonedaLocal" datasource="#session.DSN#">
						select Mcodigo
						from Empresas
						where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfset varMonedaL = rsMonedaLocal.Mcodigo>
					<cfif rsPFllave.Mcodigo NEQ varMonedaL>
						<cfquery name="rsTCC" datasource="#arguments.dsn#">
						select count(1) as CantidadPF
						from #PF_aplicacion# pfa
						where (pfa.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.PFTcodigoRef#">
							and pfa.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
							and pfa.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
							and pfa.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">)
							OR
							(pfa.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
							and pfa.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
							and pfa.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
							and pfa.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">)
					</cfquery>
						<cfquery name="rsTC" datasource="#arguments.dsn#">
						select sum(TipoCambio)/<cfqueryparam cfsqltype="cf_sql_integer" value="#rsTCC.CantidadPF#"> as TCambio
						from FAPreFacturaE pf
								inner join #PF_aplicacion# pfa
								on pf.IDpreFactura = pfa.IDpreFactura
								and pf.Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
						where (pfa.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.PFTcodigoRef#">
							and pfa.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
							and pfa.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
							and pfa.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">)
							OR
							(pfa.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
							and pfa.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
							and pfa.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
							and pfa.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">)
					</cfquery>
						<cfset varTCambio = rsTC.TCambio>
					<cfelse>
						<cfset varTCambio = 1>
					</cfif>
					<!--- Se prepara el Numero de Documento para la Orden de Impresion --->
					<cfquery name="rsNumOI" datasource="#arguments.dsn#">
					select isnull(max(OImpresionNumero),0) + 1 as NumOI
					from FAEOrdenImpresion
					where Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
					<cfset varNumOI = rsNumOI.NumOI>
					<cfset varDocOI = "OI-" & rsNumOI.NumOI>
					<cfset varPFTcodigo = rsPFtransaccion.PFTcodigo>
					<cfset varCCTcodigoRef = rsPFtransaccion.CCTcodigoRef>
					<cfset varFormato = rsPFtransaccion.FMT01COD>
					<!---<cfdump var="No Orden: #varNumOI#">
						<cfdump var="Document: #varDocOI#">
						<cfdump var="Socio: #rsPFllave.SNcodigo#">
						<cfdump var="Moneda: #rsPFllave.Mcodigo#">
						<cfdump var="Trans: #varCCTcodigoRef#">
						<cfdump var="Formato: #varFormato#">
						<cfdump var="Ofic: #rsPFllave.Ocodigo#">
						<cfdump var="Cuenta: #varSNcuenta#">
						<cfdump var="Descuento: #varDescuento#">
						<cfdump var="Fecha: #now()#">
						<cfdump var="Usuair: #arguments.Usuario#">
						<cfdump var="Dir: #varIDdireccion#">
						<cfdump var="Tipo Cam: #varTCambio#">
						<cf_dump var="Cod: #arguments.Usucodigo#"> --->
					<!--- Inserta Encabezado de la Orden de Impresion --->
					<cfquery name="insertOIE" datasource="#arguments.dsn#">
					insert into FAEOrdenImpresion
						(OImpresionNumero, OIdocumento, Ecodigo, SNcodigo, Mcodigo,
							CCTcodigo, FormatoImpresion, Ocodigo, Ccuenta, Rcodigo,
							OIdescuento, OIimpuesto, OItotal, OIfecha, OIusurio,
							OIvencimiento, OIvendedor, id_direccionFact, id_direccionEnvio,
							OIdiasvencimiento, OIObservacion, OItipoCambio, OIEstado,
							BMUsucodigo, TESRPTCid, TESRPTCietu, OIieps)
					values
						(<cfqueryparam cfsqltype="cf_sql_integer" value="#varNumOI#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#varDocOI#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCCTcodigoRef#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#varFormato#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#varSNcuenta#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.Rcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_money"   value="#varDescuento#">,
							0,0,<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Usuario#">,
							<cfqueryparam cfsqltype="cf_sql_date"    value="#rsPFllave.FechaVen#">,
							null,
							<cfif varIDdireccion EQ "">
							null,
							null,
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#varIDdireccion#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#varIDdireccion#">,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.vencimiento#">,<!---Aqui pongo  los dias de vencimiento--->
							null,
							<cfqueryparam cfsqltype="cf_sql_float" value="#varTCambio#">,
							'P',
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESRPTCid#">,
							<cfif rsCCTransaccion.CCTtipo EQ 'C'>	<!--- 1=Documento Normal DB, 0=Documento Contrario CR --->
							0,
							<cfelse>
							1,
							</cfif>
							0
							)
						<cf_dbidentity1 datasource="#arguments.DSN#">
				</cfquery>
					<cf_dbidentity2 datasource="#arguments.DSN#" name="insertOIE">
					<cfquery name="rsOIDetalles" datasource="#arguments.dsn#">
					select IDpreFactura
					from #PF_aplicacion# pf
					where pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
					and pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
					and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
					and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
				</cfquery>
					<cfset varOficina = rsPFllave.Ocodigo>
					<cfset varDetalle = 1>
					<cfloop query="rsOIDetalles">
						<!--- Reversa Estimados Previos --->
						<cfquery datasource="#arguments.dsn#">
						insert into #PF_reversa# (DdocumentoREF, CCTcodigoREF, CCTcodigoREV,CFid,CCuenta)
						select pf.DdocumentoREF, pf.CCTcodigoREF, t.CCTCodigoRef as CCTcodigoREV,#Var_CFid#,#Var_CcuentaDef#
						from FAPreFacturaE pf
								inner join Documentos d
									inner join CCTransacciones t
									on d.Ecodigo = t.Ecodigo
									and d.CCTcodigo = t.CCTcodigo
									and t.CCTestimacion = 1
								on pf.Ecodigo = d.Ecodigo
								and pf.DdocumentoREF = d.Ddocumento
								and pf.CCTcodigoREF = d.CCTcodigo
								and d.Dsaldo > 0
						where pf.Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
						and pf.IDpreFactura = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDetalles.IDpreFactura#">
						and pf.TipoDocumentoREF = 0
					</cfquery>
						<cfquery name="rsDatos" datasource="#arguments.dsn#">
						select IDpreFactura, Linea, Ecodigo, Cantidad, TipoLinea, Aid, Alm_Aid, Icodigo, Cid, CFid, Descripcion, Descripcion_Alt, PrecioUnitario, DescuentoLinea, TotalLinea, BMUsucodigo, fechaalta, ts_rversion, ccuenta, codIEPS, isnull(FAMontoIEPSLinea,0) as FAMontoIEPSLinea, afectaIVA
						from FAPreFacturaD
						where Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
						and IDpreFactura = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDetalles.IDpreFactura#">
					</cfquery>
						<cfloop query="rsDatos">
							<!--- Busca la Cuenta Contable para El detalle --->
							<cfif rsDatos.TipoLinea EQ "A">
								<cfquery name="rsCuentaC" datasource="#arguments.dsn#">
								select case when tr.CCTafectacostoventas = 1
										then iac.IACcostoventa else iac.IACinventario end as Ccuenta
								from Existencias exi, IAContables iac, CCTransacciones tr
								where exi.Aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Aid#">
									and exi.Alm_Aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Alm_Aid#">
								and iac.IACcodigo = exi.IACcodigo
									and iac.Ecodigo = exi.Ecodigo
								and exi.Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
								and tr.Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
								and tr.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCCTcodigoRef#">
							</cfquery>
							<cfelse>
								<cfquery name="rsCuentaC" datasource="#arguments.dsn#">
								select Ccuenta
								from CContables cc
									inner join Conceptos c
									on cc.Ecodigo = c.Ecodigo
									and cc.Cformato = c.Cformato
								where
									c.Cid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Cid#">
									and c.Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
							</cfquery>
							</cfif>
							<cfif isdefined("rsCuentaC") and rsCuentaC.Ccuenta NEQ "" and len(ltrim(rsCuentaC.Ccuenta))>
								<cfset varCcuenta = rsCuentaC.Ccuenta>
							<cfelseif len(rsDatos.Ccuenta) LTE 0>
								<cfif rsDatos.TipoLinea EQ "A">
									<cfquery name="rsErrorC" datasource="#arguments.dsn#">
									select Adescripcion
									from Articulos
									where Aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Aid#">
											and Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
								</cfquery>
									<cfabort showerror="Articulo: #rsErrorC.Adescripcion# no tiene Cuenta Definida">
								<cfelse>
									<cfquery name="rsErrorC" datasource="#arguments.dsn#">
									select Cdescripcion
									from Conceptos
									where Cid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Cid#">
										and Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
								</cfquery>
									<cfabort showerror="Concepto: #rsErrorC.Cdescripcion# no tiene Cuenta Definida">
								</cfif>
							</cfif>
							<!---ABCO. Verifica si inserta Detalle o Actualiza uno ya existente--->
							<cfquery name="rsVerificaDet" datasource="#arguments.dsn#">
							select * from #PF_EControl#
							where
							ItemTipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.TipoLinea#">
							<cfif rsDatos.TipoLinea EQ "A">
								and ItemCodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Aid#">
							<cfelse>
								and ItemCodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Cid#">
							</cfif>
							<cfif rsDatos.TipoLinea EQ "A">
									and OIDAlmacen = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Alm_Aid#">
							<cfelse>
									and isnull(OIDAlmacen,-1) = -1
							</cfif>
						<!---ERBG Pone el Cuenta Default INICIA--->
							<cfif isdefined("Form.opt_CC")>
								and Ccuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#Var_CcuentaDef#">
						<cfelse>
								<cfif len(rsDatos.Ccuenta) GT 0>
									and Ccuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Ccuenta#">
								<cfelse>
									and Ccuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCcuenta#">
								</cfif>
							</cfif>
						<!---ERBG Pone el Cuenta Default FIN--->
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
							and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varOficina#">
							and Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Icodigo#">
						<!---ERBG Pone el Centro Funcional Default INICIA--->
							<cfif isdefined("Form.opt_CF")>
								and CFid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Var_CFid#">
						<cfelse>
								and CFid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.CFid#">
							</cfif>
						<!---ERBG Pone el Centro Funcional Default FIN--->
						</cfquery>
							<cfif rsVerificaDet.recordcount GT 0 and varAgrupaItem>
								<!---ABCO. Actualiza el registro del detalle--->
								<cfquery datasource="#arguments.dsn#">
								update FADOrdenImpresion
										set OIDCantidad = 	OIDCantidad + <cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.Cantidad#">,
									OIDtotal 		= 	OIDtotal + <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.TotalLinea#">,
									OIDdescuento 	= 	OIDdescuento + <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.DescuentoLinea#">,
									OIMontoIEPSLinea = 	OIMontoIEPSLinea + <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.FAMontoIEPSLinea#">,
									OIDPrecioUni 	= 	(OIDtotal + <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.TotalLinea#"> + OIDdescuento + <cfqueryparam cfsqltype="cf_sql_money"value="#rsDatos.DescuentoLinea#">)/(OIDCantidad + <cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.Cantidad#">,
									<cfif form.IEscalonado EQ 0>
										, afectaIVA = 1
								<cfelse>
										, afectaIVA = 0
									</cfif>)
								where
								OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVerificaDet.OImpresionID#">
								and OIDetalle = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVerificaDet.OIDetalle#">

							</cfquery>
							<cfelse>
								<cfquery datasource="#arguments.dsn#">
								insert FADOrdenImpresion
									(OImpresionID, OIDetalle, ItemTipo, ItemCodigo, OIDAlmacen,
										Ccuenta, Ecodigo, OIDdescripcion,OIDdescnalterna,Dcodigo,
										OIDCantidad , OIDPrecioUni , OIDtotal,
										OIDdescuento, Icodigo, CFid, BMUsucodigo, codIEPS, OIMontoIEPSLinea, afectaIVA)
								values
									(<cfqueryparam cfsqltype="cf_sql_integer" value="#insertOIE.identity#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#varDetalle#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.TipoLinea#">,
										<cfif rsDatos.TipoLinea EQ "A">
											<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Aid#">,
										<cfelse>
											<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Cid#">,
										</cfif>
										<cfif rsDatos.TipoLinea EQ "A">
											<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Alm_Aid#">,
										<cfelse>
											null,
										</cfif>
								<!---ERBG Pone el Cuenta Default INICIA--->
									<cfif isdefined("Form.opt_CC")>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Var_CcuentaDef#">,
									<cfelse>
											<cfif len(rsDatos.Ccuenta) GT 0>
											<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Ccuenta#">,
											<cfelse>
											<cfqueryparam cfsqltype="cf_sql_integer" value="#varCcuenta#">,
											</cfif>
										</cfif>

										<cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Descripcion#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Descripcion_Alt#">,
										null,
										<cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.Cantidad#">,
										<cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.PrecioUnitario#">,
										<cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.TotalLinea#">,
										<cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.DescuentoLinea#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Icodigo#">,
								<!---ERBG Pone el Centro Funcional Default INICIA--->
										<cfif isdefined("Form.opt_CF")>
											<cfqueryparam cfsqltype="cf_sql_integer" value="#Var_CFid#">,
									<cfelse>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.CFid#">,
										</cfif>
								<!---ERBG Pone el Centro Funcional Default FIN--->
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.codIEPS#">,
										<cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.FAMontoIEPSLinea#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.afectaIVA#">
									)
							</cfquery>
								<!----ABCO. Inserta en la tabla de Control--->
								<cfquery name="rsInsertControl" datasource="#arguments.dsn#">
								insert into #PF_EControl#
										(OImpresionID,
											OIDetalle,
											ItemTipo,
											ItemCodigo,
											OIDAlmacen,
											Ccuenta,
											Ecodigo,
											Ocodigo,
											Icodigo,
											CFid)
								values
											(<cfqueryparam cfsqltype="cf_sql_integer" value="#insertOIE.identity#">,
											<cfqueryparam cfsqltype="cf_sql_integer" value="#varDetalle#">,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.TipoLinea#">,
											<cfif rsDatos.TipoLinea EQ "A">
												<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Aid#">,
										<cfelse>
												<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Cid#">,
											</cfif>
											<cfif rsDatos.TipoLinea EQ "A">
												<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Alm_Aid#">,
										<cfelse>
												null,
											</cfif>
									<!---ERBG Pone el Cuenta Default INICIA--->
										<cfif isdefined("Form.opt_CC")>
											<cfqueryparam cfsqltype="cf_sql_integer" value="#Var_CcuentaDef#">,
									<cfelse>
												<cfif len(rsDatos.Ccuenta) GT 0>
													<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Ccuenta#">,
												<cfelse>
													<cfqueryparam cfsqltype="cf_sql_integer" value="#varCcuenta#">,
												</cfif>
										</cfif>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#varOficina#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Icodigo#">,
										<!---ERBG Pone el Centro Funcional Default INICIA--->
										<cfif isdefined("Form.opt_CF")>
											<cfqueryparam cfsqltype="cf_sql_integer" value="#Var_CFid#">
									<cfelse>
											<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.CFid#">
										</cfif>
										)
											<!---ERBG Pone el Centro Funcional Default FIN--->
							</cfquery>
								<cfset varDetalle = varDetalle + 1>
							</cfif>
						</cfloop>
						<!--- Loop Detalles --->
						<!--- Actualiza el Descuento de la OI con el descuento de la Prefctura --->
						<cfquery name="rsDescuentoPF" datasource="#arguments.DSN#">
						select isnull(Descuento,0) as Descuento
						from FAPreFacturaE
						where Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
						and IDpreFactura = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDetalles.IDpreFactura#">
					</cfquery>
						<cfquery datasource="#arguments.DSN#">
						update FAEOrdenImpresion
						set OIdescuento = OIdescuento +
							<cfif isdefined("rsDescuentoPF") and rsDescuentoPF.Descuento NEQ ""> <cfqueryparam cfsqltype="cf_sql_money" value="#rsDescuentoPF.Descuento#">
							<cfelse> 0
							</cfif>
						where Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
						and OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#insertOIE.identity#">
					</cfquery>
						<!--- Actualiza El estatus de las PreFacturas a Terminadas --->
						<cfquery datasource="#arguments.DSN#">
						update FAPreFacturaE
							set	Estatus='T'
						where Ecodigo= <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
							and IDpreFactura = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDetalles.IDpreFactura#">
							and Estatus in ('P','E')
					</cfquery>
					</cfloop>
					<!--- Loop de Encabezados --->
					<!--- Actualiza los Totales en el encabezado de La Orden de Impresion --->
					<cfquery name="rsTotalesOI" datasource="#arguments.DSN#">
					select sum(d.OIDdescuento) as sumDescuento, sum(OIDCantidad * OIDPrecioUni) as sumSubTotal, SUM(OIMontoIEPSLinea) as IEPS,
						case i.IEscalonado
							when 1 then
								sum((((OIDCantidad * OIDPrecioUni) - d.OIDdescuento) + d.OIMontoIEPSLinea) * (i.Iporcentaje / 100))
							else
								sum(((OIDCantidad * OIDPrecioUni) - d.OIDdescuento) * (i.Iporcentaje / 100))
							end as sumImpuesto
					from FADOrdenImpresion d
						inner join Impuestos i
							on i.Icodigo = d.Icodigo
								and i.Ecodigo = d.Ecodigo
						left join Impuestos ii
							on ii.Icodigo = d.codIEPS
								and ii.Ecodigo = d.Ecodigo
					where d.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
						and d.OImpresionID = <cfqueryparam value="#insertOIE.identity#" cfsqltype="cf_sql_numeric">
					group by i.IEscalonado
				</cfquery>
					<cfif isdefined('rsTotalesOI')
						and rsTotalesOI.recordCount GT 0
						and rsTotalesOI.sumSubTotal NEQ ''
						and rsTotalesOI.sumImpuesto NEQ ''
						and rsTotalesOI.sumDescuento NEQ ''>
						<cfset TotalCot = 0>
						<cfset TotalCot = (rsTotalesOI.sumSubTotal - rsTotalesOI.sumDescuento + rsTotalesOI.IEPS + rsTotalesOI.sumImpuesto)>
						<cfquery name="update" datasource="#arguments.DSN#">
						update FAEOrdenImpresion
						set
						OIimpuesto 	= isnull(OIimpuesto,0) + <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalesOI.sumImpuesto#">,
						OIieps 		= isnull(OIieps,0) + <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalesOI.IEPS#">,
						OItotal 	= isnull(OItotal,0) + <cfqueryparam cfsqltype="cf_sql_money" value="#TotalCot#"> - isnull(OIdescuento,0)
						where Ecodigo= <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
							and OImpresionID = <cfqueryparam value="#insertOIE.identity#" cfsqltype="cf_sql_numeric">
					</cfquery>
					<cfelse>
						<cfquery name="update" datasource="#arguments.DSN#">
						update FAEOrdenImpresion
							set
								OIImpuesto	= 0,
								OIieps		= 0,
								OItotal		= 0
						where Ecodigo= <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
							and OImpresionID = <cfqueryparam value="#insertOIE.identity#" cfsqltype="cf_sql_numeric">
					</cfquery>
					</cfif>
					<!--- Actualiza la Tabla de Prefacturas especificando el documento generado por la aplicacion--->
					<cfquery datasource="#arguments.DSN#">
					update FAPreFacturaE
					set DdocumentoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varDocOI#">,
					CCTcodigoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCCTcodigoRef#">,
					TipoDocumentoREF = 1
					from FAPreFacturaE a
						inner join #PF_aplicacion# pf
						on a.IDpreFactura = pf.IDpreFactura
					where a.Ecodigo= <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
						and pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
						and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
						and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
						and
						(pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
							or
							pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.PFTcodigoRef#">)
				</cfquery>
					<!--- Guarda Registro en Bitacora de Movimientos PF --->
					<cfquery datasource="#arguments.DSN#">
					insert FABitacoraMovPF (Ecodigo, IDpreFactura, DdocumentoREF, CCTcodigoREF, SNcodigoREF,
							FechaAplicacion, TipoMovimiento, BMUsucodigo)
					select  <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">,
							a.IDpreFactura,  <cfqueryparam cfsqltype="cf_sql_varchar" value="#varDocOI#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCCTcodigoRef#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
							'I',
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">
					from FAPreFacturaE a
						inner join #PF_aplicacion# pf
						on a.IDpreFactura = pf.IDpreFactura
					where a.Ecodigo= <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
						and pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
						and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
						and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
						and
						(pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
							or
							pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.PFTcodigoRef#">)
				</cfquery>
				<cfelse>
					<!--- Si no Genera Documento Se marca la PreFactura como Terminada --->
					<cfquery datasource="#arguments.DSN#">
						update FAPreFacturaE
							set	Estatus='T'
						from FAPreFacturaE a
							inner join #PF_aplicacion# pf
							on a.IDpreFactura = pf.IDpreFactura
						where a.Ecodigo= <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
							and pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
							and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
							and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
							and pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
							and a.Estatus in ('P','E')
				</cfquery>
					<!--- Si no Genera Documento Reversa Estimados Previos --->
					<cfquery name="rsDocRev" datasource="#arguments.dsn#">
						insert into #PF_reversa# (DdocumentoREF, CCTcodigoREF, CCTcodigoREV)
					select pf.DdocumentoREF, pf.CCTcodigoREF, t.CCTCodigoRef as CCTcodigoREV
					from FAPreFacturaE pf
						inner join Documentos d
								inner join CCTransacciones t
							on d.Ecodigo = t.Ecodigo
							and d.CCTcodigo = t.CCTcodigo
							and t.CCTestimacion = 1
						on pf.Ecodigo = d.Ecodigo
						and pf.DdocumentoREF = d.Ddocumento
						and pf.CCTcodigoREF = d.CCTcodigo
						and d.Dsaldo > 0
						inner join #PF_aplicacion# pfa
						on pf.IDpreFactura = pfa.IDpreFactura
						and pf.TipoDocumentoREF = 0
					where pf.Ecodigo= <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
						and pfa.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
						and pfa.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
						and pfa.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
						and pfa.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
				</cfquery>
				</cfif>
			</cftransaction>
			<!--- Reversa Los Estimados Previos --->
			<cfquery name="rsDocRev" datasource="#arguments.dsn#">
				select distinct DdocumentoREF, CCTcodigoREF, CCTcodigoREV,COALESCE(CFid,0) as CFid,COALESCE(CCuenta,0) as CCuenta
				from #PF_reversa#
			</cfquery>
			<cfif isdefined("rsDocRev") AND rsDocRev.recordcount GT 0>
				<cfif rsDocRev.CCTcodigoREF NEQ "" and rsDocRev.DdocumentoREF NEQ "" and rsDocRev.CCTcodigoREV NEQ "">
					<cfloop query="rsDocRev">
						<cfinvoke
							component="sif.Componentes.ReversionDocNoFact"
							method="Reversion"
							Modulo="CXC"
							debug="false"
							ReversarTotal="true"
							CCTcodigo="#rsDocRev.CCTcodigoREF#"
							CCTCodigoRef="#rsDocRev.CCTcodigoREV#"
							Ddocumento="#rsDocRev.DdocumentoREF#"
							CFid="#rsDocRev.CFid#"
							CCuenta="#rsDocRev.CCuenta#"
							/>
					</cfloop>
					<!--- Loop de Reversa--->
				</cfif>
			</cfif>
		</cfloop>
		<!---Loop de Llave --->
	</cffunction>


</cfcomponent>
