<html>
<head>
	<cf_templatecss>
</head>

<body>
	<cfinclude template="TP_documentosDatosRequeridosConfig.cfm">

	<cfset modoDet = "ALTA">
	<cfif isdefined("Form.id_campo")>
		<cfset modoDet = "CAMBIO">
		
		<cfquery name="rsTipoCampo" datasource="#session.tramites.dsn#">
			select 	a.id_tipo,
					a.id_campo,
					a.nombre_campo,
					a.id_tipocampo,
					b.nombre_tipo, 
					case when b.clase_tipo = 'S' then 'Simple'
						 when b.clase_tipo = 'L' then 'Lista Valores'
						 when b.clase_tipo = 'T' then 'Tabla Interna'
						 when b.clase_tipo = 'C' then 'Complejo'
						 else ''
					end as clase,
					case when b.clase_tipo = 'S' and b.tipo_dato = 'F' then 'Fecha'
						 when b.clase_tipo = 'S' and b.tipo_dato = 'N' then 'N&uacute;mero'
						 when b.clase_tipo = 'S' and b.tipo_dato = 'B' then 'S&iacute;/No'
						 when b.clase_tipo = 'S' and b.tipo_dato = 'S' then 'Alfanum&eacute;rico'
						 else null
					end 
					||
					case when b.clase_tipo = 'S' and b.tipo_dato = 'N' and b.longitud is not null then '(' || <cf_dbfunction name="to_char" args="b.longitud">
						 when b.clase_tipo = 'S' and b.tipo_dato = 'S' and b.longitud is not null then '(' || <cf_dbfunction name="to_char" args="b.longitud">
						 else null
					end 
					||
					case when b.clase_tipo = 'S' and b.tipo_dato = 'N' and b.escala is not null then ',' || <cf_dbfunction name="to_char" args="b.escala">
						 when b.clase_tipo = 'S' and b.tipo_dato = 'S' and b.escala is not null then ',' || <cf_dbfunction name="to_char" args="b.escala">
						 else null
					end 
					||
					case when b.clase_tipo = 'S' and b.tipo_dato = 'N' and b.longitud is not null then ')'
						 when b.clase_tipo = 'S' and b.tipo_dato = 'S' and b.longitud is not null then ')'
						 else null
					end as tipo,
					b.nombre_tabla,
					a.es_obligatorio,
					a.es_descripcion
			from DDTipoCampo a
				inner join DDTipo b
					on b.id_tipo = a.id_tipocampo
			where a.id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_campo#">
			and a.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">
		</cfquery>

	</cfif>
	
	<cfquery name="rsLista" datasource="#session.tramites.dsn#">
		select 	a.id_tipo,
				a.id_campo,
				a.nombre_campo,
				a.id_tipocampo,
				b.nombre_tipo, 
				case when b.clase_tipo = 'S' then 'Simple'
					 when b.clase_tipo = 'L' then 'Lista Valores'
					 when b.clase_tipo = 'T' then 'Tabla Interna'
					 when b.clase_tipo = 'C' then 'Complejo'
					 else ''
				end as clase,
				case when b.clase_tipo = 'S' and b.tipo_dato = 'F' then 'Fecha'
					 when b.clase_tipo = 'S' and b.tipo_dato = 'N' then 'N&uacute;mero'
					 when b.clase_tipo = 'S' and b.tipo_dato = 'B' then 'S&iacute;/No'
					 when b.clase_tipo = 'S' and b.tipo_dato = 'S' then 'Alfanum&eacute;rico'
					 else null
				end 
				||
				case when b.clase_tipo = 'S' and b.tipo_dato = 'N' and b.longitud is not null then '(' || <cf_dbfunction name="to_char" args="b.longitud">
					 when b.clase_tipo = 'S' and b.tipo_dato = 'S' and b.longitud is not null then '(' || <cf_dbfunction name="to_char" args="b.longitud">
					 else null
				end 
				||
				case when b.clase_tipo = 'S' and b.tipo_dato = 'N' and b.escala is not null then ',' || <cf_dbfunction name="to_char" args="b.escala">
					 when b.clase_tipo = 'S' and b.tipo_dato = 'S' and b.escala is not null then ',' || <cf_dbfunction name="to_char" args="b.escala">
					 else null
				end 
				||
				case when b.clase_tipo = 'S' and b.tipo_dato = 'N' and b.longitud is not null then ')'
					 when b.clase_tipo = 'S' and b.tipo_dato = 'S' and b.longitud is not null then ')'
					 else null
				end as tipo,
				b.nombre_tabla,
				a.es_obligatorio,
				a.es_descripcion
		from DDTipoCampo a
			inner join DDTipo b
				on b.id_tipo = a.id_tipocampo
		where a.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">
		order by b.clase_tipo desc, a.nombre_campo
	</cfquery>

	<cfset cols = " id_tipo as id_tipocampo,
					nombre_tipo, 
					case when clase_tipo = 'S' then 'Simple'
						 when clase_tipo = 'L' then 'Lista Valores'
						 when clase_tipo = 'T' then 'Tabla Interna'
						 when clase_tipo = 'C' then 'Complejo'
						 else ''
					end as clase,
					case when clase_tipo = 'S' and tipo_dato = 'F' then 'Fecha'
						 when clase_tipo = 'S' and tipo_dato = 'N' then 'Numero'
						 when clase_tipo = 'S' and tipo_dato = 'B' then 'Si/No'
						 when clase_tipo = 'S' and tipo_dato = 'S' then 'Alfanumerico'
						 else null
					end 
					||
					case when clase_tipo = 'S' and tipo_dato = 'N' and longitud is not null then '(' || convert(varchar, longitud)
						 when clase_tipo = 'S' and tipo_dato = 'S' and longitud is not null then '(' || convert(varchar, longitud)
						 else null
					end 
					||
					case when clase_tipo = 'S' and tipo_dato = 'N' and escala is not null then ',' || convert(varchar, escala)
						 when clase_tipo = 'S' and tipo_dato = 'S' and escala is not null then ',' || convert(varchar, escala)
						 else null
					end 
					||
					case when clase_tipo = 'S' and tipo_dato = 'N' and longitud is not null then ')'
						 when clase_tipo = 'S' and tipo_dato = 'S' and longitud is not null then ')'
						 else null
					end as tipo,
					nombre_tabla">

<cfif modoDet EQ "CAMBIO">
	<script language="javascript" type="text/javascript">
		function funcEliminar() {
			<cfoutput>
			if (confirm('Esta seguro de que desea eliminar el campo #rsTipoCampo.nombre_campo# de la composicion del tipo de dato #rsTipoDato.nombre_tipo#?')) {
				return true;
			} else {
				return false;
			}
			</cfoutput>
		}
	</script>
</cfif>

<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td width="50%" valign="top">
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="desplegar" value="nombre_campo, tipo, nombre_tabla"/>
					<cfinvokeargument name="etiquetas" value="Nombre Campo, Tipo, Nombre Tabla"/>
					<cfinvokeargument name="formatos" value="S, S, S"/>
					<cfinvokeargument name="align" value="left, left, left"/>
					<cfinvokeargument name="ajustar" value=""/>
					<cfinvokeargument name="formName" value="lista"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="irA" value="#CurrentPage#"/>
					<cfinvokeargument name="keys" value="id_tipo, id_campo"/>
					<cfinvokeargument name="cortes" value="clase"/>
					<cfinvokeargument name="maxRows" value="0"/>
				</cfinvoke> 
			</td>
			<td width="50%" valign="top">
				<form name="form1" method="post" action="DiccDato-sql-form3.cfm">
					<input type="hidden" name="id_tipo" value="<cfif isdefined("Form.id_tipo") and Len(Trim(Form.id_tipo))>#Form.id_tipo#</cfif>">
					<input type="hidden" name="id_campo" value="<cfif isdefined("Form.id_campo") and Len(Trim(Form.id_campo))>#Form.id_campo#</cfif>">
					<table width="100%"  border="0" cellspacing="0" cellpadding="2">
					  <tr>
						<td class="fileLabel" align="right" nowrap>Nombre Campo:</td>
						<td>
							<input type="text" name="nombre_campo" size="40" maxlength="60" value="<cfif modoDet EQ "CAMBIO">#HtmlEditFormat(rsTipoCampo.nombre_campo)#</cfif>">
						</td>
					  </tr>
					  <tr>
						<td class="fileLabel" align="right" nowrap>Campo:</td>
						<td>
							<cfset valores = "">
							<cfif modoDet EQ "CAMBIO">
								<cfset valores = " #rsTipoCampo.id_tipocampo#, #rsTipoCampo.nombre_tipo#, #rsTipoCampo.tipo#, #rsTipoCampo.nombre_tabla#">
							</cfif>
							<cf_conlis title="Lista de Tipos"
								campos = "id_tipocampo,nombre_tipo,tipo,nombre_tabla" 
								desplegables = "N,S,S,N" 
								size = "0,15,30,0"
								values = "#valores#" 
								tabla = "DDTipo"
								columnas = "#PreserveSingleQuotes(cols)#"
								filtro = "es_documento = 0 
										  and id_tipo <> #Form.id_tipo#
										  order by clase desc, nombre_tipo"
								desplegar = "nombre_tipo,tipo,nombre_tabla"
								etiquetas = "Nombre, Tipo, Nombre Tabla"
								formatos = "S,S,S"
								align = "left,left,left"
								conexion = "#session.tramites.dsn#"
								cortes = "clase"
								>
						</td>
					  </tr>
					  <tr>
					    <td class="fileLabel" align="right" nowrap>
							<input name="es_obligatorio" type="checkbox" id="es_obligatorio" value="1" <cfif modoDet EQ "CAMBIO" and rsTipoCampo.es_obligatorio EQ 1> checked</cfif>>
						</td>
					    <td>Es obligatorio</td>
				      </tr>
					  <tr>
					    <td class="fileLabel" align="right" nowrap><input name="es_descripcion" type="checkbox" id="es_descripcion" value="1" <cfif modoDet EQ "CAMBIO" and rsTipoCampo.es_descripcion EQ 1> checked</cfif>></td>
					    <td>Es descripci&oacute;n </td>
				      </tr>
					  <tr>
					    <td colspan="2">&nbsp;</td>
				      </tr>
					  <tr>
					    <td colspan="2" align="center">
							<cfif modoDet EQ "CAMBIO">
								<input type="submit" name="btnModificar" value="Modificar">
								<input type="submit" name="btnEliminar" value="Eliminar" onClick="javascript: return funcEliminar();">
								<input type="submit" name="btnNuevo" value="Nuevo" onClick="javascript: location.href = '#CurrentPage#?id_tipo=#Form.id_tipo#'; return false;">
							<cfelse>
								<input type="submit" name="btnAgregar" value="Agregar">
							</cfif>
						</td>
				      </tr>
					</table>
				</form>
			
			</td>
		</tr>
	</table>
</cfoutput>
	
</body>
</html>