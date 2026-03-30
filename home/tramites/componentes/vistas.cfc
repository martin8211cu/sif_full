<cfcomponent>
	<!---
		FUNCION GETVISTA
		DESCRIPCION ESTA FUNCION TRAE LA DEFINICION DE UNA VISTA PARA PINTAR UN FORM
		PARAMETROS REQUERIDOS ID_VISTA, ID_TIPO
		RETORNA QUERY CON DEFINICION PARA PINTER UN FORM
	--->
	<cffunction name="getVista" access="public" output="false" returntype="query">
		<cfargument name="id_vista" required="yes" type="numeric">
		<!--- Lee todos los datos de la vista --->
		<cfquery datasource="#session.tramites.dsn#" name="esta_vigente_aun">
			select a.id_vista
			from DDVista a
			where a.id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_vista#">
			  and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(LSDateFormat(Now(),'dd/mm/yyyy'))#">
			  between a.vigente_desde and a.vigente_hasta
		</cfquery>
		<!---
		<cfif esta_vigente_aun.recordcount eq 0>
			<cfthrow message="Error en Vistas. La vista solicitada ha expirado. Proceso Cancelado!.">
		</cfif>
		--->
		<cfquery name="rsVista" datasource="#session.tramites.dsn#">
			select a.id_vista, a.id_tipo, a.nombre_vista, a.titulo_vista, 
				b.id_campo, b.orden_campo, b.es_encabezado, b.etiqueta_campo, 
				c.id_tipocampo, c.es_obligatorio, c.es_descripcion, c.nombre_campo, 
				d.nombre_tipo, d.clase_tipo, d.tipo_dato, d.mascara, d.formato, 
				d.valor_minimo, d.valor_maximo, d.longitud, d.escala, d.nombre_tabla,
				d.es_documento, e.id_vistagrupo, e.etiqueta, e.columna, e.orden, e.borde
			from DDVista a 
				inner join DDVistaCampo b 
					on 	b.id_vista 	= a.id_vista
				inner join DDTipoCampo c
					on c.id_campo = b.id_campo
				inner join DDTipo d
					on d.id_tipo = c.id_tipocampo
				inner join DDVistaGrupo e
					on e.id_vistagrupo = b.id_vistagrupo
			where a.id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_vista#">
			  <!---and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(LSDateFormat(Now(),'dd/mm/yyyy'))#">
			  between a.vigente_desde and a.vigente_hasta--->
			order by e.columna, e.orden, b.orden_campo
		</cfquery>
		<!--- Valida la existencia de la vista --->
		<cfif rsVista.recordcount eq 0>
			<cfthrow message="Error en Vistas. La vista solicitada no tiene campos favor revisar la definición de la Vista. Proceso Cancelado!.">
		</cfif>
		<cfreturn rsVista>
	</cffunction>
	<!--- 
		FUNCION GETREGISTRO
		DESCRIPCION ESTA FUNCION TRAE LOS NOMBRES DE LOS CAMPOS DE UN TIPO DADO
		PARAMETROS REQUERIDOS ID_TIPO
		RETORNA QUERY CON NOMBRES DE LOS CAMPOS PARA PINTAR UNA LISTA
	--->
	<cffunction name="getRegistro" access="public" output="false" returntype="query">
		<cfargument name="id_registro" required="true" type="numeric">
		<cfquery name="rsData" datasource="#session.tramites.dsn#">
			select id_campo, valor 
			from DDCampo
			where id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_registro#">
		</cfquery>
		<cfquery name="rsPersona" datasource="#session.tramites.dsn#">
			select a.id_persona, identificacion_persona, nombre, apellido1, apellido2
			from DDRegistro a
				inner join TPPersona b
				on a.id_persona = b.id_persona				
			where id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_registro#">
		</cfquery>
		<cfset ColumnList1 = "id_persona, identificacion_persona, nombre, apellido1, apellido2">
		<cfloop query="rsData">
			<cfset ColumnList1 = ColumnList1 & ",C_#rsData.id_campo#">
		</cfloop>
		<cfset returnQry = QueryNew(ColumnList1)>
		<cfset QueryAddRow(returnQry,1)>
		<cfset QuerySetCell(returnQry,"id_persona",rsPersona.id_persona)>
		<cfset QuerySetCell(returnQry,"identificacion_persona",rsPersona.identificacion_persona)>
		<cfset QuerySetCell(returnQry,"nombre",rsPersona.nombre)>
		<cfset QuerySetCell(returnQry,"apellido1",rsPersona.apellido1)>
		<cfset QuerySetCell(returnQry,"apellido2",rsPersona.apellido2)>
		<cfloop query="rsData">
			<cfset QuerySetCell(returnQry,"C_#rsData.id_campo#",valor)>
		</cfloop>
		<cfreturn returnQry>
	</cffunction>
	<!--- 
		FUNCION GETCAMPOSLISTA
		DESCRIPCION ESTA FUNCION TRAE LOS NOMBRES DE LOS CAMPOS DE UN TIPO DADO
		PARAMETROS REQUERIDOS ID_TIPO
		RETORNA QUERY CON NOMBRES DE LOS CAMPOS PARA PINTAR UNA LISTA
	--->
	<cffunction name="getCamposLista" access="public" output="true" returntype="query">
		<cfargument name="id_tipo" required="true" type="numeric">
		<cfargument name="debug" required="false" type="boolean">
		<cfquery name="rsResultTitles1" datasource="#session.tramites.dsn#">
			select 	tc.id_campo, tc.nombre_campo,
				b.clase_tipo, b.tipo_dato
			from DDTipoCampo tc
				inner join DDTipo b
					on b.id_tipo = tc.id_tipocampo
			where tc.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_tipo#">
			  and tc.es_descripcion = 1
		</cfquery>
		<cfif isdefined("Arguments.Debug") and Arguments.Debug Eq true>
			<cfdump var="#rsResultTitles1#">
		</cfif>
		<cfset returnTlt1 = QueryNew("id_campo,nombre_campo,nombre_objeto,formato,align")>
		<cfloop query="rsResultTitles1">
			<cfset QueryAddRow(returnTlt1,1)>
			<cfset QuerySetCell(returnTlt1,"id_campo","#id_campo#",CurrentRow)>
			<cfset QuerySetCell(returnTlt1,"nombre_campo","#nombre_campo#",CurrentRow)>
			<cfset QuerySetCell(returnTlt1,"nombre_objeto","C_#id_campo#",CurrentRow)>
			<cfif clase_tipo EQ 'S' and tipo_dato EQ 'F'>
				<cfset QuerySetCell(returnTlt1,"formato","D",CurrentRow)>
			<cfelse>
				<cfset QuerySetCell(returnTlt1,"formato","S",CurrentRow)>
			</cfif>
			<cfset QuerySetCell(returnTlt1,"align","left",CurrentRow)>
		</cfloop>
		<cfreturn returnTlt1>
	</cffunction>
	<!--- 
		FUNCION GETLISTA
		DESCRIPCION ESTA FUNCION TRAE LOS DATOS LOS REGISTROS QUE CUMPLAN CON LOS PARAMETROS REQUERIDOS
		PARAMETROS REQUERIDOS ID_TIPO
		PARAMETROS NO REQUERIDOS ID_INST, ID_PERSONA, ID_REGISTRO, F_DESDE, F_HASTA, IDENTIFICACION_PERSONA, NOMBRE_PERSONA, APELLIDO_PERSONA, DATOS_VARIABLES
		RETORNA QUERY CON DATOS PARA PINTAR UNA LISTA
		DEFINICION DEL QUERY RETORNADO
			ID_REGISTRO
			ID_PERSONA
			ID_TIPO
			ID_INST
			PAGADO
			DATOS_VARIABLES
		EJEMPLO CON USANDOLO CON COMPONENTE DE LISTAS:
		
			<cfinvoke 
				component="home.tramites.componentes.vistas" 
				method="getCamposLista" 
				id_tipo="89"
				returnvariable="getListaCampos"></cfinvoke>
			
			<cfset navegacion = "">
			<cfinvoke 
				component="home.tramites.componentes.vistas" 
				method="getLista" 
				id_tipo="89"
				returnvariable="getListaValores">
					<!--- Para pasar parámetros dinámicos de filtro automático --->
					<cfloop list="#ValueList(getListaCampos.nombre_objeto)#" index="name">
						<cfif isdefined("form.Filtro_#name#") and len(trim(evaluate("form.Filtro_#name#")))>
							<cfinvokeargument name="#name#" value="#Trim(Evaluate('form.Filtro_#name#'))#">
							<cfset navegacion = navegacion&"&Filtro_#name#="&Trim(Evaluate('form.Filtro_#name#'))>
						<cfelseif isdefined("url.Filtro_#name#") and len(trim(evaluate("url.Filtro_#name#")))>
							<cfinvokeargument name="#name#" value="#Trim(Evaluate('url.Filtro_#name#'))#">
							<cfset navegacion = navegacion&"&Filtro_#name#="&Trim(Evaluate('url.Filtro_#name#'))>
						</cfif>
					</cfloop>
			</cfinvoke>
			
			<cfset formatos="">
			<cfset align="">
			<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
			<cfloop from="1" to="#ListLen(ValueList(getListaCampos.nombre_objeto))#" index="i">
				<cfset formatos=formatos&iif(len(formatos),DE(","),DE(""))&"S">
				<cfset align=align&iif(len(align),DE(","),DE(""))&"left">
			</cfloop>
			
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				query="#getListaValores#"
				desplegar="#ValueList(getListaCampos.nombre_objeto)#"
				etiquetas="#ValueList(getListaCampos.nombre_campo)#"
				formatos="#formatos#"
				align="#align#"
				mostrar_filtro="true"
				irA="#CurrentPage#"
				navegacion="#navegacion#"
				maxrows="5"
				></cfinvoke>
	--->
	<cffunction name="getLista" access="public" output="true" returntype="query">
		<cfargument name="id_tipo" required="true" type="numeric">
		<cfargument name="id_inst" required="false" type="numeric">
		<cfargument name="id_persona" required="false" type="numeric">
		<cfargument name="id_registro" required="false" type="numeric">
		<cfargument name="f_desde" required="false" type="date">
		<cfargument name="f_hasta" required="false" type="date">
		<cfargument name="identificacion_persona" required="false" type="string">
		<cfargument name="nombre" required="false" type="string">
		<cfargument name="apellido1" required="false" type="string">
		<cfargument name="apellido2" required="false" type="string">
		<cfargument name="debug" required="false" type="boolean">
		<cfset var returnQry = QueryNew("")>
		<cfif isdefined("Arguments.Debug") and Arguments.Debug Eq true>
			<cfdump var="#Arguments#">
		</cfif>
		<cfquery name="rsResults" datasource="#session.tramites.dsn#">
			select 	b.id_registro, b.id_persona, b.id_tipo, b.id_inst, b.pagado, 
				d.identificacion_persona, d.nombre, d.apellido1, d.apellido2, 
				tc.id_campo, tc.nombre_campo, (case when tc.es_descripcion = 1 then c.valor else '' end) as valor
			from DDTipo a
				inner join DDRegistro b
					on b.id_tipo = a.id_tipo
				inner join DDTipoCampo tc
					on tc.id_tipo = b.id_tipo
					and tc.es_descripcion = 1
				inner join DDCampo c
					on  c.id_campo = tc.id_campo
					and c.id_registro = b.id_registro
				left outer join TPPersona d
					on d.id_persona = b.id_persona
			where a.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_tipo#">
					<cfif isdefined("Arguments.id_inst") and len(trim(Arguments.id_inst))>
						and b.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_inst#">
					</cfif>
					<cfif isdefined("Arguments.id_persona") and len(trim(Arguments.id_persona))>
						and b.id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_persona#">
					</cfif>
					<cfif isdefined("Arguments.id_registro") and len(trim(Arguments.id_registro))>
						and b.id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_registro#">
					</cfif>
					<cfif isdefined("Arguments.f_desde") and len(trim(Arguments.f_desde))>
						and <cf_dbfunction name="to_datechar" args="b.BMfechamod" datasource="#session.tramites.dsn#"> >= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.f_desde#">
					</cfif>
					<cfif isdefined("Arguments.f_hasta") and len(trim(Arguments.f_hasta))>
						and <cf_dbfunction name="to_datechar" args="b.BMfechamod" datasource="#session.tramites.dsn#"> <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.f_hasta#">
					</cfif>
					<cfif isdefined("Arguments.identificacion_persona") and len(trim(Arguments.identificacion_persona))>
						and d.identificacion_persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.identificacion_persona#">
					</cfif>
					<cfif isdefined("Arguments.nombre") and len(trim(Arguments.nombre))>
						and d.nombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.nombre#">
					</cfif>
					<cfif isdefined("Arguments.apellido1") and len(trim(Arguments.apellido1))>
						and d.apellido1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.apellido1#">
					</cfif>
					<cfif isdefined("Arguments.apellido2") and len(trim(Arguments.apellido2))>
						and d.apellido2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.apellido2#">
					</cfif>
			order by b.id_registro, tc.orden_campo, c.id_campo
		</cfquery>
		<cfif isdefined("Arguments.Debug") and Arguments.Debug Eq true>
			<cfdump var="#rsResults#">
		</cfif>
		<cfset rsResultTitles = getCamposLista(Arguments.id_tipo)>
		<cfset TitleList = "ID_REGISTRO, ID_PERSONA, ID_TIPO, ID_INST, PAGADO, IDENTIFICACION_PERSONA, NOMBRE, APELLIDO1, APELLIDO2">
		<cfset orderby = ''>
		<cfloop query="rsResultTitles">
			<cfset TitleList = TitleList & ",C_#id_campo#">
			<cfset orderby = ListAppend(orderby,"C_#id_campo#")>
		</cfloop>
		<cfset returnQry = QueryNew(TitleList)>
		<cfoutput query="rsResults" group="id_registro">
			<cfset incluir = true>
			<cfoutput>
				<cfif isdefined("arguments.C_#id_campo#") and trim(evaluate("arguments.C_#id_campo#")) GT 0 and evaluate("arguments.C_#id_campo#") NEQ valor>
					<cfset incluir = false>
				</cfif>
			</cfoutput>
			<cfif incluir>
				<cfset QueryAddRow(returnQry,1)>
				<cfset QuerySetCell(returnQry,"ID_REGISTRO",rsResults.ID_REGISTRO,returnQry.recordcount)>
				<cfset QuerySetCell(returnQry,"ID_PERSONA",rsResults.ID_PERSONA,returnQry.recordcount)>
				<cfset QuerySetCell(returnQry,"ID_TIPO",rsResults.ID_TIPO,returnQry.recordcount)>
				<cfset QuerySetCell(returnQry,"ID_INST",rsResults.ID_INST,returnQry.recordcount)>
				<cfset QuerySetCell(returnQry,"PAGADO",rsResults.PAGADO,returnQry.recordcount)>
				<cfset QuerySetCell(returnQry,"IDENTIFICACION_PERSONA",rsResults.IDENTIFICACION_PERSONA,returnQry.recordcount)>
				<cfset QuerySetCell(returnQry,"NOMBRE",rsResults.NOMBRE,returnQry.recordcount)>
				<cfset QuerySetCell(returnQry,"APELLIDO1",rsResults.APELLIDO1,returnQry.recordcount)>
				<cfset QuerySetCell(returnQry,"APELLIDO2",rsResults.APELLIDO2,returnQry.recordcount)>
				<cfoutput>
					<cfset QuerySetCell(returnQry,"C_#id_campo#",valor,returnQry.recordcount)>
				</cfoutput>
			</cfif>
		</cfoutput>
		<!--- los resultados deben ordenarse --->
		<cftry>
		<cfquery dbtype="query" name="returnQry">
			select * from returnQry order by #orderby#
		</cfquery>
		<cfcatch type="database"></cfcatch>
		</cftry>
		<cfreturn returnQry>
	</cffunction>
	
	<cffunction name="unir_valor" access="public" output="false" returntype="string">
		<!---
			junta dos valores en un solo string de la forma {id,valor}.
			para usar en tags de listas y datos complejos.
			se espera que el id sea un unico dato numerico (que no contenga comas)
			y se espera que el dato se separe con separar_valor.
		--->
		<cfargument name="idref" type="string">
		<cfargument name="valor" type="string">
		<cfreturn '{ ' & Arguments.idref & ' , ' & Arguments.valor & ' }'>
	</cffunction>
	
	<cffunction name="separar_valor" access="public" output="false" returntype="struct">
		<!---
			separa un valor de la forma {id,valor} en un struct con id y valor.
			para usar en tags de listas y datos complejos.
			se espera que el id sea un unico dato numerico (que no contenga comas)
			y se espera que el dato haya sido unido con unir_valor.
		--->
		<cfargument name="valor" type="string">
		<cfset var retvalst = StructNew()>
		<cfset var stripbrc = ''>
		<cfif Left(Arguments.valor,1) IS '{'
			And Right(Arguments.valor,1) IS '}'
			And ListLen(Arguments.valor) GT 1>
			<cfset stripbrc = Mid(Arguments.valor,2,Len(Arguments.valor)-2)>
			<cfset retvalst.idref = Trim(ListFirst(stripbrc))>
			<cfset retvalst.valor = Trim(ListRest(stripbrc))>
		<cfelse>
			<cfset retvalst.idref = ''>
			<cfset retvalst.valor = Trim(Arguments.valor)>
		</cfif>
		<cfreturn retvalst>
	</cffunction>
	
	<!--- 
		FUNCION UPDREGISTRO
		DESCRIPCION ACTUALIZA LOS DATOS DE UN REGISTRO DADO
		PARAMETROS REQUERIDOS ID_REGISTRO, DATOS_VARIABLES
	--->
	<cffunction name="updRegistro" access="public" output="false" returntype="string">
		<cfargument name="id_registro" required="true" type="numeric">
		<cfargument name="id_persona" required="false" type="numeric" default="0">		
		<cfargument name="debug" required="false" type="boolean" default="false">

		<cfquery datasource="#session.tramites.dsn#" name="registro">
			select r.id_tipo, r.id_persona, t.nombre_tipo
			from DDRegistro r
				left join DDTipo t
					on r.id_tipo = t.id_tipo
			where r.id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_registro#">
		</cfquery>
			
		<cfset update_persona = IsDefined('Arguments.id_persona') AND
			  (Arguments.id_persona NEQ 0) AND
			  (registro.id_persona NEQ Arguments.id_persona) >
		<cfif Arguments.id_persona EQ 0>
			<cfset Arguments.id_persona = registro.id_persona>
		</cfif>

		
		<cfquery name="rsResults" datasource="#session.tramites.dsn#">
			select tc.id_campo, t2.clase_tipo, t2.tipo_dato
			from DDTipoCampo tc
				join DDTipo t2
					on t2.id_tipo = tc.id_tipocampo
			where tc.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#registro.id_tipo#">
		</cfquery>
		<cfif isdefined("Arguments.Debug") and Arguments.Debug Eq true>
			<cfdump var="#rsResults#">
		</cfif>
		
		<!---
			ver si no existe otro registro con la misma llava
		--->
		<cfinvoke component="#this#" method="buscar_por_llave"
			 argumentcollection="#Arguments#"
			 excepto="#Arguments.id_registro#"
			 id_persona="#Arguments.id_persona#"
			 id_tipo="#registro.id_tipo#"
			 returnvariable="buscarlo" />
		<cfif buscarlo.RecordCount>
			<cfthrow message="Ya hay un registro con igual #ValueList(rsCamposLlave.nombre_campo)#." detail="IDs=#ValueList(buscarlo.id_registro)#">
		</cfif>
		
		<!---
		<cftransaction>
		no se hace CFTRANSACTION porque entonces no se podría
		invocar desde otra transacción. La transacción la debe
		iniciar quien invoca el componente
		--->
			<cfset updated_count = 0>
			<cfloop query="rsResults">
				<cfif StructKeyExists(Arguments,'C_'&rsResults.id_campo)>
					<cfset valor_nuevo = Arguments['C_'&rsResults.id_campo]>
					<cfset idref_nuevo    = ''>
					<cfif ListFind('L,C',rsResults.clase_tipo)>
						<cfset valor_struct = separar_valor(valor_nuevo)>
						<cfset valor_nuevo  = valor_struct.valor>
						<cfset idref_nuevo  = valor_struct.idref>
					</cfif>
					<cfquery datasource="#session.tramites.dsn#" name="valor_anterior">
						select valor,valor_ref
						from DDCampo
						where id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_registro#">
							and id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsResults.id_campo#">
					</cfquery>
					<cfif valor_anterior.RecordCount EQ 0>
						<cfset updated_count = updated_count + 1>
						<cfquery datasource="#session.tramites.dsn#">
							insert into DDCampo (id_registro, id_campo, valor, valor_ref, BMfechamod, BMUsucodigo)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_registro#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsResults.id_campo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#valor_nuevo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#idref_nuevo#" null="#Len(Trim(idref_nuevo)) EQ 0#">, 
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
							)
						</cfquery>
					<cfelseif Trim(valor_anterior.valor) NEQ Trim(valor_nuevo)
						OR Trim(valor_anterior.valor_ref) NEQ Trim(idref_nuevo)>
						<cfset updated_count = updated_count + 1>
						<cfquery datasource="#session.tramites.dsn#">
							update DDCampo
							set valor = <cfqueryparam cfsqltype="cf_sql_char" value="#valor_nuevo#">, 
								valor_ref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idref_nuevo#" null="#Len(Trim(idref_nuevo)) EQ 0#">, 
								BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
								BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
							where id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_registro#">
								and id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsResults.id_campo#">
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
			
			<cfif updated_count OR update_persona>
				<cfquery datasource="#session.tramites.dsn#">
					update DDRegistro
					set BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					    id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#" null="#Len(session.tramites.id_funcionario) eq 0#">,
					    id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#" null="#Len(session.tramites.id_ventanilla) eq 0#">
						<cfif update_persona>
						,id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_persona#">
						</cfif>
					where id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_registro#">
				</cfquery>
				
				
				<cfinvoke component="bitacora" method="registrar"
					id_persona="#Arguments.id_persona#"
					accion="modifica"
					texto="tipo: #registro.nombre_tipo#, documento no: #Arguments.id_registro#">
				</cfinvoke>
				
			</cfif>
			
		<!---
		</cftransaction>
		no se hace CFTRANSACTION porque entonces no se podría
		invocar desde otra transacción. La transacción la debe
		iniciar quien invoca el componente
		--->
		<cfreturn "OK">
	</cffunction>
	<!--- 
		FUNCION INSREGISTRO
		DESCRIPCION INSERT UN NUEVO REGISTRO
		PARAMETROS REQUERIDOS DATOS_VARIABLES
	--->
	<cffunction name="insRegistro" access="public" output="false" returntype="numeric">
		<cfargument name="id_tipo" required="true" type="numeric">
		<cfargument name="id_persona" required="false" type="numeric" default="0">		
		<cfargument name="debug" required="false" type="boolean" default="false">
		
		<cfquery name="rsResults" datasource="#session.tramites.dsn#">
			select 	tc.id_campo, t2.clase_tipo, t2.tipo_dato, t2.nombre_tipo
			from DDTipoCampo tc
				join DDTipo t2
					on t2.id_tipo = tc.id_tipocampo
			where tc.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_tipo#">
		</cfquery>
		<cfif isdefined("Arguments.Debug") and Arguments.Debug Eq true>
			<cfdump var="#rsResults#">
		</cfif>
		
		<!---
			ver si no existe el registro
		--->
		<cfinvoke component="#this#" method="buscar_por_llave"
			 argumentcollection="#Arguments#" returnvariable="buscarlo" />			 
		<cfif buscarlo.RecordCount>
			<cfthrow message="Ya hay un registro con igual #ValueList(rsCamposLlave.nombre_campo)#." detail="IDs=#ValueList(buscarlo.id_registro)#">
		</cfif>
		
		<!---
		<cftransaction>
		no se hace CFTRANSACTION porque entonces no se podría
		invocar desde otra transacción. La transacción la debe
		iniciar quien invoca el componente
		--->
			<cfquery name="insert" datasource="#session.tramites.dsn#">
				insert into DDRegistro	(id_persona, id_tipo, 
					id_funcionario, id_ventanilla,
					BMfechamod, BMUsucodigo)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_persona#" null="#arguments.id_persona eq 0#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_tipo#">,
					
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#" null="#Len(session.tramites.id_funcionario) eq 0#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#" null="#Len(session.tramites.id_ventanilla) eq 0#">,
					
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				)
				<cf_dbidentity1 datasource="#session.tramites.dsn#" verificar_transaccion="false">
			</cfquery>
			<cf_dbidentity2 name="insert" datasource="#session.tramites.dsn#" verificar_transaccion="false">
			<cfloop query="rsResults">
				<cfif StructKeyExists(Arguments,'C_'&rsResults.id_campo)>
					<cfquery datasource="#session.tramites.dsn#">
						<cfset valor_nuevo = Arguments['C_'&rsResults.id_campo]>
						<cfset idref_nuevo    = ''>
						<cfif ListFind('L,C',rsResults.clase_tipo)>
							<cfset valor_struct = separar_valor(valor_nuevo)>
							<cfset valor_nuevo  = valor_struct.valor>
							<cfset idref_nuevo  = valor_struct.idref>
						</cfif>
						
						insert into DDCampo (id_registro, id_campo, valor, valor_ref, BMfechamod, BMUsucodigo)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#insert.identity#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsResults.id_campo#">, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#valor_nuevo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#idref_nuevo#" null="#Len(Trim(idref_nuevo)) EQ 0#">, 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						)
					</cfquery>
				</cfif>
			</cfloop>
			<cfinvoke component="bitacora" method="registrar"
				id_persona="#Arguments.id_persona#"
				accion="inserta"
				texto="tipo: #rsResults.nombre_tipo#, documento no: #insert.identity#">
			</cfinvoke>
		<!---
		</cftransaction>
		no se hace CFTRANSACTION porque entonces no se podría
		invocar desde otra transacción. La transacción la debe
		iniciar quien invoca el componente
		--->
		<cfreturn insert.identity>
	</cffunction>
	
	<cffunction name="delRegistro" access="public" output="false" returntype="string">
		<cfargument name="id_registro" required="true" type="numeric">
		<!---
		<cftransaction>
		no se hace CFTRANSACTION porque entonces no se podría
		invocar desde otra transacción. La transacción la debe
		iniciar quien invoca el componente
		--->
			<cfquery datasource="#session.tramites.dsn#">
				delete from DDCampo
				where id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_registro#">
			</cfquery>
			<cfquery datasource="#session.tramites.dsn#">
				delete from DDRegistro
				where id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_registro#">
			</cfquery>
		<!---
		</cftransaction>
		no se hace CFTRANSACTION porque entonces no se podría
		invocar desde otra transacción. La transacción la debe
		iniciar quien invoca el componente
		--->

	<cfreturn "OK">
	</cffunction>
	
	<cffunction name="buscar_por_llave">
		<!--- 
			busca un registro por tipo y llaves, y persona opcionalmente.
			Arguments.excepto: registro por excluir, util cuando la busqueda
			                   es de registros duplicados
			al terminar, queda disponible el rsCamposLlave
		--->
		<cfargument name="id_tipo" required="true" type="numeric">
		<cfargument name="id_persona" required="false" type="numeric" default="0">
		<cfargument name="excepto" required="yes" type="numeric" default="0">
		<cfargument name="debug" required="false" type="boolean" default="false">
		
		<cfquery name="rsCamposLlave" datasource="#session.tramites.dsn#">
			select 	tc.id_campo, t2.clase_tipo, t2.tipo_dato, tc.nombre_campo
			from DDTipoCampo tc
				join DDTipo t2
					on t2.id_tipo = tc.id_tipocampo
					and tc.es_llave = 1
			where tc.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_tipo#">
		</cfquery>
		<cfif isdefined("Arguments.Debug") and Arguments.Debug Eq true>
			<cfdump var="#rsCamposLlave#">
		</cfif>
		
		<cfif rsCamposLlave.RecordCount EQ 0>
			<cfreturn QueryNew('id_registro')>
		</cfif>
		
		<!---
		<cftransaction>
		no se hace CFTRANSACTION porque entonces no se podría
		invocar desde otra transacción. La transacción la debe
		iniciar quien invoca el componente
		--->
			<cfquery name="buscarlo" datasource="#session.tramites.dsn#">
				select r.id_registro
				from DDRegistro r
				where 
					<cfif Arguments.id_persona EQ 0 or Len(Arguments.id_persona) EQ 0>
						r.id_persona is null
					<cfelse>
						r.id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_persona#">
					</cfif>
				<cfif Arguments.excepto>
					and r.id_registro != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.excepto#">
				</cfif>
				<cfloop query="rsCamposLlave">
					<cfif StructKeyExists(Arguments,'C_'&rsCamposLlave.id_campo)>
						<cfset valor_nuevo = Arguments['C_'&rsCamposLlave.id_campo]>
						<cfset idref_nuevo    = ''>
						<cfif ListFind('L,C',rsCamposLlave.clase_tipo)>
							<cfset valor_struct = separar_valor(valor_nuevo)>
							<cfset valor_nuevo  = valor_struct.valor>
							<cfset idref_nuevo  = valor_struct.idref>
						</cfif>
						and exists (
							select 1 from DDCampo c
							where c.id_registro = r.id_registro
							  and c.id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCamposLlave.id_campo#">
							  <cfif Len(idref_nuevo)>
							  and c.valor_ref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idref_nuevo#" null="#Len(Trim(idref_nuevo)) EQ 0#">
							  <cfelse>
							  and c.valor = <cfqueryparam cfsqltype="cf_sql_char" value="#valor_nuevo#">
							  </cfif> )
					</cfif>
				</cfloop>
			</cfquery>
		<!---
		</cftransaction>
		no se hace CFTRANSACTION porque entonces no se podría
		invocar desde otra transacción. La transacción la debe
		iniciar quien invoca el componente
		--->
		<cfreturn buscarlo>
	
	</cffunction>
	
</cfcomponent>