<cfquery name="datorequisito" datasource="#session.tramites.dsn#" >
	select 	tc.id_tipo, 
			tc.nombre_campo,
		    tc.id_campo,
		    tc.nombre_campo,
			tc.id_tipocampo, 
			tp.tipo_dato,
			tp.formato,
			tp.mascara,
		    tp.clase_tipo, 
		    tp.tipo_dato, 
		    tp.mascara, 
		    tp.formato, 
		    tp.valor_minimo, 
		    tp.valor_maximo, 
		    tp.longitud, 
		    tp.escala, 
		    tp.nombre_tabla,
			tdc.modificable,
			tdc.campo_fijo,
			tdc.id_campo_req

		from TPTramite tr
		join TPDocumento d
			on d.id_documento = tr.id_documento_generado
		join DDTipoCampo tc
			on tc.id_tipo = d.id_tipo
		join DDTipo tp
			on tp.id_tipo = tc.id_tipocampo
			
		left join TPTramiteCierreDoc tdc
			on tdc.id_tramite = tr.id_tramite
			and tdc.id_campo_doc = tc.id_campo
			
	where tr.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_tramite#">
	order by tc.orden_campo
</cfquery>

<cffunction name="trae_valor">
	<cfargument name="campo_fijo">
	<cfargument name="id_campo_req">

	<cfset el_valor     = "">
	<cfset el_valor_ref = "">
	
	<!---
		buscar el valor, en caso de que exista
	--->
	<cfif Len(Arguments.campo_fijo)>
		<cfquery dbtype="query" name="buscar_campo_fijo">
			select columna
			from datos_fijos
			where codigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.campo_fijo#">
		</cfquery>
		<cfif Len(buscar_campo_fijo.columna)>
			<cfset el_valor = Evaluate('infotramite.' & buscar_campo_fijo.columna)>
			<cfif IsDate(el_valor)>
				<cfset el_valor = DateFormat(el_valor,'dd/mm/yyyy')>
			</cfif>
			<cfif Arguments.campo_fijo EQ 'IDN'>
				<cfset el_valor_ref = data.id_persona>
			</cfif>
		</cfif>
		<!---
		valor:#Arguments.campo_fijo# - #buscar_campo_fijo.columna# - #el_valor#--->
	<cfelseif Len(Arguments.id_campo_req)>
		<cfquery datasource="#session.tramites.dsn#" name="buscar_campo_requisito">
			select cam.valor, cam.valor_ref
				from TPInstanciaRequisito ir
				join DDCampo cam
					on cam.id_registro = ir.id_registro
					and cam.id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_campo_req#">
			where ir.id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_instancia#">
		</cfquery>
		<!---<cfdump var="#buscar_campo_requisito#">--->
		<cfset el_valor = buscar_campo_requisito.valor>
		<cfset el_valor_ref = buscar_campo_requisito.valor_ref>
	</cfif><!---
	<cfoutput>trae valor(#campo_fijo#,#id_campo_req#):#el_valor#</cfoutput>--->
</cffunction>

<cfinvoke component="home.tramites.componentes.cierre"
	method="datos_fijos" returnvariable="datos_fijos">
</cfinvoke>

<cfif Len(infotramite.id_tipoident)>
	<!--- solo para documentos que son un tipo de identificacion --->
	<cfquery name="rsCamposPersona" datasource="#session.tramites.dsn#">
		select 
			e.campo_persona,
			e.id_campo_req,
			e.campo_fijo,
			e.modificable
		from TPTramiteCierrePers e
		where e.id_tramite =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_tramite#">
	</cfquery>
	
	<!---
		JOIN A PATA; NI MODO
	--->
	<cfquery dbtype="query" name="rsDatosFijos">
		select 
			codigo,
			nombre,
			tipo_dato,
			'' as id_campo_req,
			'' as campo_fijo,
			0  as modificable
		from datos_fijos
		<cfif infotramite.es_fisica NEQ 1>
		where codigo in ('IDN','NOM')
		</cfif>
	</cfquery>
	
	<cfloop query="rsDatosFijos">
		<cfquery dbtype="query" name="subquery">
			select id_campo_req, campo_fijo, modificable
			from rsCamposPersona
			where campo_persona = '#rsDatosFijos.codigo#'
		</cfquery>
		<cfset QuerySetCell(rsDatosFijos, 'id_campo_req', subquery.id_campo_req, rsDatosFijos.CurrentRow)>
		<cfset QuerySetCell(rsDatosFijos, 'campo_fijo',   subquery.campo_fijo,   rsDatosFijos.CurrentRow)>
		<cfset QuerySetCell(rsDatosFijos, 'modificable',  subquery.modificable,  rsDatosFijos.CurrentRow)>
	</cfloop>
	<!---<cfdump var="#rsDatosFijos#">--->
</cfif>
	
<cfset datos_var = ''>
<cfset popup = 0>
	<table width="100%" cellpadding="2" cellspacing="0" border="0"  style="border:1px solid gray; ">
	<cfif Len(infotramite.id_tipoident)>
		<tr><td class="subTitulo" colspan="3"><strong>Datos Personales</strong></td></tr>
		<cfoutput query="rsDatosFijos">
			<cfset trae_valor(rsDatosFijos.codigo, rsDatosFijos.id_campo_req)>
			<tr><td>#HTMLEditFormat(nombre)#</td>
			<td>
			<cfif rsDatosFijos.tipo_dato EQ 'F'>
				<cf_sifcalendario name="P_#rsDatosFijos.codigo#" value="#HTMLEditFormat(el_valor)#" form="form2" >
			<cfelseif rsDatosFijos.codigo EQ 'SEX'>
				<select name="P_#rsDatosFijos.codigo#">
					<option value="F">Femenino</option>
					<option value="M">Masculino</option>
				</select>
			<cfelseif rsDatosFijos.codigo EQ 'IDN'>
				<input type="text" name="P_#rsDatosFijos.codigo#" value="#HTMLEditFormat(el_valor)#" onfocus="this.select()" maxlength="30"
				onkeyup="validar_identificacion()"
				onchange="validar_identificacion()"
				/>
				<img src="../../images/Borrar01_S.gif" name="img_ident_mal" width="20" height="18" border="0" id="img_ident_mal" >
				<img src="../../images/check-verde.gif" name="img_ident_ok" width="18" height="20" border="0" id="img_ident_ok"  style="display:none">
				<img src="../../images/blank.gif" height="20" width="1" border="0">
				<br>
				<em>Capturar como: #HTMLEditFormat(infotramite.mascara) #</em>
			<cfelse>
				<input type="text" name="P_#rsDatosFijos.codigo#" value="#HTMLEditFormat(el_valor)#" onfocus="this.select()" maxlength="30" />
			</cfif>
			
			</td>
			<td>&nbsp;</td>
			</tr>
		</cfoutput>
	</cfif>
	
		<cfoutput query="datorequisito">
			<cfset trae_valor(datorequisito.campo_fijo, datorequisito.id_campo_req)>
			<tr>
			<td width="1%" nowrap>
			<cfif NOT (clase_tipo EQ 'S' and tipo_dato EQ 'B')>
				<label for="dato_#datorequisito.id_campo#">
				<strong>#datorequisito.nombre_campo#:&nbsp;</strong></label>
				</cfif>
			</td>
			<td>
				<cf_tipo clase_tipo="#datorequisito.clase_tipo#" 
						 name="dato_#datorequisito.id_campo#" 
						 id_tipo="#datorequisito.id_tipo#" 
						 tipo_dato="#datorequisito.tipo_dato#" 
						 mascara="#datorequisito.mascara#" 
						 formato="#datorequisito.formato#" 
						 valor_minimo="#datorequisito.valor_minimo#" 
						 valor_maximo="#datorequisito.valor_maximo#" 
						 longitud="#datorequisito.longitud#" 
						 escala="#datorequisito.escala#" 
						 nombre_tabla="#datorequisito.nombre_tabla#"
						 value="#el_valor#"
						 valueid="#el_valor_ref#"
						 id_tipocampo="#id_tipocampo#"
						 form="form2">
						 
			<cfif (clase_tipo EQ 'S' and tipo_dato EQ 'B')>
				<label for="dato_#datorequisito.id_campo#">
				<strong>#datorequisito.nombre_campo#&nbsp;</strong></label>
				</cfif>
			</td>
			<td align="right" width="16">
				
			</td>
			</tr>
		</cfoutput>
	</table> 
