<cfparam name="url.bitacoraid" type="numeric" default="#form.bitacoraid#">
<cfparam name="url.historia" type="string" default="">


<cfquery datasource="aspmonitor" name="data">
	select bitacoraid,oper,tabla,
		pk,ak,descripcion,
		anterior,nuevo,columnas,
		Usucodigo,Usulogin,fecha
	from MonBitacora
	where bitacoraid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.bitacoraid#">
</cfquery>

<cfquery datasource="asp" name="config">
	select PBllaves, PBalterna, PBlista
	from PBitacora
	where PBtabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#data.tabla#">
</cfquery>

<cfset dbtype = Application.dsinfo['aspmonitor'].type>

<cfset data_list = data>


<style type="text/css">
	table.valores { 
		background-color:#9999CC;
	}
	table.valores tr td { 
		background-color:#FFFFFF; 
	}
	table.valores tr.actual td { 
		background-color:#edffff; 
		border-top:2px solid blue; 
		border-bottom:2px solid blue; 
	}
	table.valores tr.actual td.first_col { 
		border-left:2px solid blue; 
	}
	table.valores tr.actual td.last_col  { 
		border-right:2px solid blue; 
	}
	table.valores tr.par td { 
		background-color:#ededed; 
	}
	table.valores tr td.hdr { 
		background-color:#cccccc; 
	}

	table.bitheader {
		background-color:#999999;
		font-size:12px;
		font-weight:bold;
		font-family:Arial, Helvetica, sans-serif;
		text-align:left;
		border:1px solid #999999 
	}
	table.bitheader tr td {
		background-color:#FFFFFF
	}
	table.bitheader tr td.hdr {
		background-color:#CCCCCC
	}

	.contenedorPrincipal {
		width: 600px;
		overflow:auto;
		margin-left: auto;
		margin-right: auto;
	}
	.td{
	    padding-bottom: 5px;
	    padding-right: 20px;
	    text-align: left;
	}

	.diferentes{
		color: red;
	}

	.iguales{
		color: blue;
	}
</style>

<cf_web_portlet_start titulo="Consulta de bitácora">
<cfoutput>
<div class="row">
	<div class="col-md-6">
		<table width="100%"   border="0" cellpadding="1" cellspacing="0">
			<tr class="subTitulo">
				<td colspan="2" class="tituloListas">Detalle de modificaci&oacute;n </td>
			</tr>
			<tr>
				<td valign="top" class='hdr'>ID modificaci&oacute;n </td>
				<td width="56%" valign="top" class='hdr'>#data.bitacoraid#</td>
			</tr>
			<tr>
				<td valign="top" class='hdr'>Tabla</td>
				<td valign="top" class='hdr'>#data.tabla#</td>
			</tr>
			<tr>
				<td valign="top" class='hdr'>Operaci&oacute;n</td>
				<td valign="top" class='hdr'>#nombre_operacion(data.oper)#
			</td>
			</tr>
			<tr>
				<td width="44%" valign="top" class='hdr'>Fecha</td>
				<td valign="top" class='hdr'>#data.fecha#</td>
			</tr>
			<tr>
				<td valign="top" class='hdr'>Usuario</td>
				<td valign="top" class='hdr'>
				<cfif LEN(TRIM(data.Usulogin))>
							#data.Usulogin#
						<cfelseif LEN(TRIM(data.Usucodigo))>
							<cfquery name="rsUsuario" datasource="asp">
									select Usulogin from Usuario where Usucodigo = #data.Usucodigo#
								</cfquery>
								#rsUsuario.Usulogin# 
						<cfelse>
							Desconocido
						</cfif>
				</td>
			</tr>
			<tr>
				<td valign="top" class='hdr'>Llave primaria
				<cfif Len(Trim(config.PBllaves))>: #config.PBllaves#</cfif></td>
				<td valign="top" class='hdr'>#HTMLEditFormat(data.pk)#</td>
			</tr>
			<cfif Len(Trim(config.PBalterna)) or Len(Trim(data.ak))>
			<tr>
				<td valign="top" class='hdr'>Llave alterna
					<cfif Len(Trim(config.PBalterna))>: #config.PBalterna#</cfif></td>
				<td valign="top" class='hdr'>#HTMLEditFormat(data.ak)#  <cfif Not Len(Trim(data.ak)) >No Disponible</cfif></td>
			</tr></cfif>
			<cfif Len(Trim(config.PBlista)) or Len(Trim(data.descripcion))>
			<tr>
				<td valign="top" class='hdr'>Descripci&oacute;n
					<cfif Len(Trim(config.PBlista))>: #config.PBlista#</cfif></td>
				<td valign="top" class='hdr'>#HTMLEditFormat(data.descripcion)#<cfif Not Len(Trim(data.descripcion))>No Disponible</cfif></td>
			</tr></cfif>
			<tr><td colspan="2" align="center" valign="middle"><hr></td></tr>
			<tr>
				<td colspan="2">
					<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
						tabla="MonBitacora"
						columnas="bitacoraid,fecha,oper,tabla,pk,ak,descripcion"
						desplegar="bitacoraid,fecha,oper,tabla,pk,ak,descripcion"
						etiquetas="Consecutivo,Fecha,Operación,Tabla,PK,AK,Descripción"
						formatos="S,S,S,S,S,S,S"
						filtro="tabla = '#data.tabla#'
							and pk = '#data.pk#'
							order by bitacoraid desc"
						align="left,left,left,left,left,left,left"
						ira				  ="lista.cfm"
						keys			  ="bitacoraid"
						conexion 		="aspmonitor">
					</cfinvoke>
				</td>
			</tr>
		</table>
	</div>
	<div class="col-md-6">
		<cfset reporte.antes = listToArray(data_list.anterior,',',true)>
		<cfset reporte.columnas = listToArray(data_list.columnas,',',true)>
		<cfset reporte.nuevo = listToArray(data_list.nuevo,',',true)>

		<div class="contenedorPrincipal">
			<table>
				<tr>
					<th class="td">Columnas</th>
					<th class="td">Anterior</th>
					<th class="td">Despues</th>
				</tr>
				<cfif ArrayLen(reporte.antes) EQ 0>
					<cfset i = 1>
					<cfloop array="#reporte.columnas#" index="columna">
						<tr>
							<td class="td">#buscarEtiqueta(columna,columnas_funcionales)#</td>
							<td class="td"> --- </td>
							<td class="iguales td">#reporte.nuevo[i]#</td>
						</tr>
						<cfset i = i +1 >
					</cfloop>
				<cfelseif ArrayLen(reporte.nuevo) EQ 0>
					<cfset i = 1>
					<cfloop array="#reporte.columnas#" index="columna">
						<tr>
							<td class="td"> #columna# </td>
							<td class="iguales td">#reporte.antes[i]#</td>
							<td class="td"> --- </td>
						</tr>
						<cfset i = i +1 >
					</cfloop>
				<cfelse>
					<cfset i = 1>
					<cfloop array="#reporte.columnas#" index="columna">
						<tr>
							<td class="td"> #columna# </td>
							<cfif arrayLen(reporte.antes) eq arrayLen(reporte.nuevo)>
								<cfset clase = evaluarColumnas( #reporte.antes[i]# , #reporte.nuevo[i]# )>
							<cfelse>
								<cfset clase = "iguales">
							</cfif>
							<td class="#clase# td">
								<cfif arrayLen(reporte.antes) eq arrayLen(reporte.nuevo)>
									#reporte.antes[i]#
								</cfif>
							</td>
							<td class="#clase# td">#reporte.nuevo[i]#</td>
						</tr>
						<cfset i = i + 1>
					</cfloop>
				</cfif>
				</table>
		</div>
	</div>
</div>



<!--- <cfset objt   				= createObject("asp.admin.bitacora.configuracion.componentes.WZBitacora-reportes")>
<cfset reporte 				= objt.generar_datosfuncionales(data_list)>

<cfset objt   				= createObject("asp.admin.bitacora.configuracion.componentes.WZbitacora-sql")>
<cfset columnas_funcionales = objt.get_columnas_tabla(data.tabla)> --->



</cfoutput>
<cf_web_portlet_end>

<cffunction name="evaluarColumnas" output="false" access="public" returntype="string">
	<cfargument name="dato1" type="string">
	<cfargument name="dato2" type="string">

	<cfif Compare(dato1,dato2) NEQ 0 >
		<cfreturn "diferentes">
	<cfelse>
		<cfreturn "iguales">
	</cfif>
</cffunction>

<cffunction name="buscarEtiqueta" output="false" access="public" returntype="string">
	<cfargument name="nombreColumna" type="string">
	<cfargument name="columnas_funcionales" type="array">

	<cfif arrayLen(Arguments.columnas_funcionales) EQ 0 >
		<cfreturn Arguments.nombreColumna>
	<cfelse>
		<cfloop array="#Arguments.columnas_funcionales#" index="columna">
			<cfif Compare(Arguments.nombreColumna, columna.nombre) EQ 0 >
				<cfreturn columna.descripcion>
			</cfif>
		</cfloop>
		<cfreturn Arguments.nombreColumna>
	</cfif>
</cffunction>

<cffunction name="nombre_operacion" output="false" returntype="string">
	<cfargument name="oper">
	<cfif Arguments.oper is 'U'>
		<cfreturn 'update'>
	<cfelseif Arguments.oper is 'I'>
		<cfreturn 'insert'>
	<cfelseif Arguments.oper is 'D'>
		<cfreturn 'delete'>
	<cfelse>
		<cfreturn Arguments.oper>
	</cfif>
</cffunction>