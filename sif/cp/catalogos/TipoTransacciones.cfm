<cf_templateheader title="Cuentas por pagar">

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo de Tipos de Transacciones de CxP'>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfset form.Pagina = url.Pagina>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
				<cfset form.Pagina = url.PageNum_Lista>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
			<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
				<cfset form.Pagina = form.PageNum>
			</cfif>
			<cfif isdefined("url.CPTcodigo") and not isdefined("form.CPTcodigo")>
				<cfset form.CPTcodigo = url.CPTcodigo >
			</cfif>

	        <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td colspan="2" valign="top">
				<cfif isdefined("session.modulo") and trim(session.modulo) EQ "CP">
					<cfinclude template="../../portlets/pNavegacionCP.cfm">
				<cfelseif isdefined("session.modulo") and trim(session.modulo) EQ "AD">
					<cfinclude template="../../portlets/pNavegacionAD.cfm">
				</cfif>
				</td>
              </tr>
              <tr>
                <td valign="top" width="50%">
				<cfset navegacion = '' >
				<cfif isdefined("form.CPTcodigo") and len(trim(form.CPTcodigo))>
					<cfset navegacion = navegacion &'&CPTcodigo=#form.CPTcodigo#' >
				</cfif>
				<cfif isdefined("form.CPTdescripcion") and len(trim(form.CPTdescripcion))>
					<cfset navegacion = navegacion &'&CPTdescripcion=#form.CPTdescripcion#' >
				</cfif>
				<cfif isdefined("form.CPTtipo") and len(trim(form.CPTtipo))>
					<cfset navegacion = navegacion &'&CPTtipo=#form.CPTtipo#' >
				</cfif>
				<cfset campos_extra = '' >
				<cfif isdefined("form.pagenum_lista")>
					<cfset campos_extra = ",'#form.pagenum_lista#' as pagenum_lista" >
				</cfif>
				<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
				<cfparam name="form.Pagina" default="1">
				<cfparam name="form.MaxRows" default="15">

				<!--- Query para los valores del CPTtipo para el filtro de la lista --->
				<cfset rsCPTtipos = QueryNew("value,description")>
				<cfset QueryAddRow(rsCPTtipos,1)>
				<cfset QuerySetCell(rsCPTtipos, "value", '', rsCPTtipos.recordcount)>
				<cfset QuerySetCell(rsCPTtipos, "description", "--Todos--", rsCPTtipos.recordcount)>
				<cfset QueryAddRow(rsCPTtipos,1)>
				<cfset QuerySetCell(rsCPTtipos, "value", 'D', rsCPTtipos.recordcount)>
				<cfset QuerySetCell(rsCPTtipos, "description", "Débito", rsCPTtipos.recordcount)>
				<cfset QueryAddRow(rsCPTtipos,1)>
				<cfset QuerySetCell(rsCPTtipos, "value", 'C', rsCPTtipos.recordcount)>
				<cfset QuerySetCell(rsCPTtipos, "description", "Crédito", rsCPTtipos.recordcount)>

				<cfset varArray = listToArray("CPTcodigo~CPTdescripcion~CPTtipo","~")>

				<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
				 returnvariable="pListaTran">
                    <cfinvokeargument name="tabla" value="CPTransacciones"/>
					<cfinvokeargument name="columnas" value="
						CPTcodigo
						,CPTdescripcion
						,case CPTtipo
							when 'D' then 'Débito'
							when 'C' then 'Crédito'
						end CPTtipo
						#preservesinglequotes(campos_extra)#"/>
					<cfinvokeargument name="desplegar" value="CPTcodigo,CPTdescripcion,CPTtipo"/>
               		<cfinvokeargument name="etiquetas" value="Transacción, Descripción, Tipo"/>
                    <cfinvokeargument name="formatos" value="S,S,S"/>
                    <cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# order by CPTcodigo"/>
                    <cfinvokeargument name="align" value="left, left, left"/>
                    <cfinvokeargument name="ajustar" value="N"/>
                    <cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="keys" value="CPTcodigo"/>
                    <cfinvokeargument name="irA" value="TipoTransacciones.cfm"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="maxRows" value="#form.MaxRows#"/>
					<cfinvokeargument name="mostrar_filtro" value="true"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>
					<cfinvokeargument name="filtrar_por_array" value="#varArray#"/>
					<cfinvokeargument name="rsCPTtipo" value="#rsCPTtipos#"/>
                  </cfinvoke>
				</td>
                <td valign="top">
					<cfinclude template="formTipoTransacciones.cfm">
				</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
            </table>
		<cf_web_portlet_end>
	<cf_templatefooter>