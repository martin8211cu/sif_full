
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
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
			<cfquery name="rsTransacciones" datasource="#Session.DSN#">
				select '' as value, 'Todas' as description from dual
				union all
				select distinct cct.CCTcodigo as value, cct.CCTdescripcion as description
				from CCTransacciones cct
				join Documentos d
					on cct.Ecodigo = d.Ecodigo
					and cct.CCTcodigo = d.CCTcodigo
				where cct.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and cct.CCTtipo = 'D'
				  and d.Dsaldo != 0
				order by 1
			</cfquery> 
			<cfquery name="rsMonedas" datasource="#Session.DSN#">
				select -1 as value, 'Todas' as description from dual
				union all
				select distinct b.Mcodigo as value, b.Mnombre as description
				from Monedas b
				join Documentos d
					on b.Ecodigo = d.Ecodigo
					and b.Mcodigo = d.Mcodigo
				where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				 and d.Dsaldo != 0
				 order by 1
			</cfquery> 
			
			<cfquery name="rsUsuarios" datasource="#Session.DSN#">
				select '' as value, 'Todos' as description from dual
				union all
				select distinct Dusuario as value, upper(Dusuario) as description
				from Documentos d
				join CCTransacciones cct
					on d.CCTcodigo = cct.CCTcodigo
					and d.Ecodigo = cct.Ecodigo and cct.CCTtipo = 'D'
				where cct.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and d.Dsaldo != 0
				
			</cfquery>                        
			
			<cfquery datasource="#session.dsn#" name="documentos">
				select d.CCTcodigo, SNidentificacion, SNnombre, CCTdescripcion, Ddocumento, Mnombre, Dfecha, Dtotal, Dsaldo, '' as esp
				from Documentos d
					join CCTransacciones cct
						on cct.Ecodigo = d.Ecodigo
						and cct.CCTcodigo = d.CCTcodigo
					join SNegocios sn
						on sn.Ecodigo = d.Ecodigo
						and sn.SNcodigo = d.SNcodigo
					join Monedas m
						on m.Ecodigo = d.Ecodigo
						and m.Mcodigo = d.Mcodigo
				where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and d.Dsaldo != 0
				  and cct.CCTtipo = 'D'
			
				  
				order by d.Dvencimiento desc
			</cfquery>
			<cfparam name="form.Pagina" default="1">
			<cfparam name="form.MaxRows" default="15">
			
			<br>
			<div class="subTitulo">
			<strong>Seleccione el documento para el cual desea modificar el Plan de Pagos</strong>
			</div>
			<br>
			<cfparam name="form.Pagina" default="1">
			<cfparam name="form.MaxRows" default="20">
			<form name="form1" method="post">
				<cfoutput>
				<input name="Pagina" type="hidden" value="#form.pagina#">
				<input name="MaxRows" type="hidden" value="#form.MaxRows#">
				</cfoutput>
				<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
					 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="Documentos d
														join CCTransacciones cct
															on cct.Ecodigo = d.Ecodigo
															and cct.CCTcodigo = d.CCTcodigo
														join SNegocios sn
															on sn.Ecodigo = d.Ecodigo
															and sn.SNcodigo = d.SNcodigo
														join Monedas m
															on m.Ecodigo = d.Ecodigo
															and m.Mcodigo = d.Mcodigo"/>
					<cfinvokeargument name="columnas" value="d.CCTcodigo, SNidentificacion, SNnombre, CCTdescripcion, Ddocumento, Mnombre, Dfecha, Dtotal, Dsaldo, '' as esp"/>
					<cfinvokeargument name="desplegar" value="SNidentificacion, SNnombre, CCTdescripcion, Ddocumento, Mnombre, Dfecha, Dtotal, Dsaldo,esp"/>
					<cfinvokeargument name="etiquetas" value="Identificaci&oacute;n, Nombre, Transacción, Documento, Moneda, Fecha, Total, Saldo, "/>
					<cfinvokeargument name="formatos" value="S,S,S,S,S,D,M,M,US"/>
					<cfinvokeargument name="filtro" value="d.Ecodigo = #session.Ecodigo#
													  and d.Dsaldo != 0
													  and cct.CCTtipo = 'D'
													  order by d.Dvencimiento desc"/>
					<cfinvokeargument name="filtrar_por" value="SNidentificacion,SNnombre,d.CCTcodigo,Ddocumento,d.Mcodigo,Dfecha,Dtotal,Dsaldo, "/>
					<cfinvokeargument name="align" value="left, left, left, left, left, left, right, right,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="incluyeForm" value="false"/>
					<cfinvokeargument name="formName" value="form1"/>	
					<cfinvokeargument name="irA" value="index2_revisar.cfm"/>
					<cfinvokeargument name="keys" value="CCTcodigo,Ddocumento"/>
					<cfinvokeargument name="Nuevo" value="index2_revisar.cfm"/>
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="MaxRows" value="#form.MaxRows#"/>
					<cfinvokeargument name="mostrar_filtro" value="true"/>
					<cfinvokeargument name="filtrar_automatico"	value="true"/>
					<cfinvokeargument name="rsCCTdescripcion" value="#rsTransacciones#"/>
					<cfinvokeargument name="rsMnombre" value="#rsMonedas#"/>
				  </cfinvoke>
			</form>
		<cf_web_portlet_end>
	<cf_templatefooter>