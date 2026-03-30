<!--- 
	PASO 1: Diseñar en PowerDesigner:
			a. Instalar PowerDesigner 15
			b. Bloquear el modelo en SVN
			c. Abrir el modelo en Sybase 12.5.1
			d. Diseñar cambios
			e. Salvar cambios
	PASO 2: Upload de cambios a CF:
			a. Instalar Programa dePDaCF.vb
			b. Escoger paquete o diagrama o tablas a generar
			c. Enviar cambios a Coldfusion
	PASO 2a: El proceso de salvar y VERIFICAR contra desarrollo se ejecuta en background
			a. Si sólo hay campos y tablas nuevas
				Sigue con la generación de la versión DBModel automáticamente
			b. Si hay cambios en características de campos
				Para el proceso
				Permite verificar los cambios
				Permite generar la versión DBModel manualmente
			c. Si faltan campos que existen en desarrollo
				Para el proceso y hay que corregir ya sea añadir en powerdesigner o borrar en desarrollo
	PASO 3: Generar nueva versión de DataBaseModel
			Las versiones DBM quedan disponibles para ser agregadas a un parche
	PASO 4: Añadir la versión en el Generador de Parches
--->

<cf_templateheader title="Consola de Actualización a los Modelos de Base de Datos" width="100%">
<cf_templatefooter>
<cf_web_portlet_start titulo="Upload de Parches de Base de Datos" width="100%">
	<cfparam name="session.dbm" default="#structNew()#">

	<cfparam name="url.ALL" default="0">
	<cfparam name="session.dbm.ALL" default="#url.ALL#">

	<cfparam name="url.uidSVN" default="">
	<cfparam name="session.dbm.uidSVN" default="#url.uidSVN#">
	<cfparam name="session.dbm.usr" default="false">
	<cfif isdefined("url.IDU")>
		<cfquery name="rsSQL" datasource="asp">
			select uidSVN from DBMuploads where IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDU#">
		</cfquery>
		<cfset session.dbm.uidSVN="#rsSQL.uidSVN#">
		<cfset session.dbm.usr="false">
		<cflocation url="DBMuploads.cfm">
	</cfif>	
	<cfif isdefined("url._")>
		<cfset session.dbm.usr="true">
	</cfif>	
	<cfif session.dbm.usr>
		<cfset LvarUIDT = ",SVN uid">
		<cfset LvarUID = ",uidSVN">
		
		<cfset session.dbm.uidSVN=url.uidSVN>
		<cfset session.dbm.ALL=url.ALL>
		<cfoutput>
		Usuario: <input value="#session.dbm.uidSVN#" onkeydown="GvarRefresh=false;if (Key(event) == 13) location.href = 'DBMuploads.cfm?uidSVN='+this.value" tabindex="1" />
		<input type="checkbox" name="ALL" <cfif session.dbm.ALL EQ 1>checked</cfif> onclick="location.href = 'DBMuploads.cfm?ALL='  + (this.checked?'1':'0')"/>
		</cfoutput>
		
	<cfelse>
		<cfset LvarUIDT = "">
		<cfset LvarUID = "">
		<cfoutput>
		Usuario: <strong>#session.dbm.uidSVN#</strong>
		</cfoutput>
	</cfif>
	<cf_dbfunction name="OP_Concat" returnvariable="CAT" datasource="asp">
    <cf_dbfunction name="to_char"	args="u.IDupl" returnvariable="IDupl" isNumber="true">
	<cfquery name="rsSQL" datasource="asp">
		select 	u.IDupl, u.des, m.modelo, u.fec, u.uidSVN, u.stsP, 
				case u.stsP
					when 0 then 
						case u.sts
							when 0 then '<strong>UPLOAD INICIADO</strong>'
							when 1 then '<strong>UPLOAD CARGADO</strong>'
							when 2 then '<strong>UPLOAD VERIFICADO</strong>'
							when 3 then '<strong>BASE DATOS ACTUALIZADA</strong>'
							when 4 then '<strong>VERSION GENERADA</strong><BR>(Falta Incluir en Parche)'
						end
						when 1 then 'Cargando Upload...'
					when 2 then 'Verificando Carga...'
					when 3 then 'Preparando Upload...'
					when 4 then 'Cargando Desarrollo...'
					when 5 then 'Comparando Desarrollo...'
					when 6 then 'Verificando Upload...'
					when 10 then 'Upload Denegado'
					when 11 then 'Revisar Cambios'
					when 21 then 'Generando Script...'
					when 22 then 'Ejecutando Script...'
					when 23 then 'Errores de Base Datos'
					when 29 then 'Generando Version...'
				end as status,
				case 
					when u.tabs=0 then 0 
					when u.tabs=1 then 1
					when u.stsP in (2,3,5,6) then tabsP 
					else round(u.tabsP*100.0/tabs,2)
				end as prc,
				msg,
				tabs,

				case when u.sts < 3 or u.sts=3 and stsP=0 then
					'<img src="/cfmx/asp/parches/images/deletesmall.gif" style="cursor:pointer" onclick="fnOP(1,' #CAT# #PreserveSingleQuotes(IDupl)# #CAT# ');" alt="Eliminar">' 
				end 
				#CAT#
				case when u.sts = 4 then
					'<img src="/cfmx/asp/parches/images/deletesmall.gif" style="cursor:pointer" onclick="fnOP(1,' #CAT# #PreserveSingleQuotes(IDupl)# #CAT# ');" alt="Eliminar">' 
				end
				#CAT#
				case when u.sts = 0 and u.stsP=0 then
					'<img src="/cfmx/asp/parches/images/arriba.gif" style="cursor:pointer" onclick="fnOP(0,' #CAT# #PreserveSingleQuotes(IDupl)# #CAT# ');" alt="Upload">' 
				end 
				#CAT#
				case when u.sts in (1,2,3) AND u.stsP in (0,10,11,23) then
					'<img src="/cfmx/asp/parches/images/w-check.gif" style="cursor:pointer" onclick="fnOP(2,' #CAT# #PreserveSingleQuotes(IDupl)# #CAT# ');">' 
				end
				#CAT#
				case when u.stsP in (0,10,11,23) and <cf_dbfunction name="lobIsNotNull" args="u.html"> then
					'<img src="/cfmx/asp/parches/images/findsmall.gif" style="cursor:pointer" onclick="fnOP(10,' #CAT# #PreserveSingleQuotes(IDupl)# #CAT# ');" alt="Resultados de Verificación">' #CAT# ' ' 
				end
				#CAT#
				case when u.sts = 2 AND u.stsP = 0 then
					'<img src="/cfmx/asp/parches/images/genScript.gif" style="cursor:pointer" onclick="fnOP(22,' #CAT# #PreserveSingleQuotes(IDupl)# #CAT# ');" alt="Generar Script en Desarrollo">' #CAT# ' ' 
				end
				#CAT#
			<cfif isdefined("url.html")>
				case when u.sts = 1 AND u.stsP = 11 OR u.sts = 2 AND u.stsP in (0) then
					'<img src="/cfmx/asp/parches/images/Script.gif" style="cursor:pointer" onclick="fnOP(40,' #CAT# #PreserveSingleQuotes(IDupl)# #CAT# ');" alt="Script de Base de Datos">' #CAT# ' ' 
				end
				#CAT# 
				case when u.sts in (1,2) and u.stsP in (23) then
					'<img src="/cfmx/asp/parches/images/Cferror.gif" style="cursor:pointer" onclick="fnOP(41,' #CAT# #PreserveSingleQuotes(IDupl)# #CAT# ');" alt="Reporte de Errores">' #CAT# ' ' 
				end
				#CAT#
				case when u.sts in (1,2) and u.stsP in (23) OR u.sts in (3, 4) and u.stsP = 0 then
					'<img src="/cfmx/asp/parches/images/Script.gif" style="cursor:pointer" onclick="fnOP(42,' #CAT# #PreserveSingleQuotes(IDupl)# #CAT# ');" alt="Resultado de la Ejecución de Base Datos">' #CAT# ' ' 
				end
				#CAT#
			</cfif>
				case when u.sts = 3 and stsP = 0 then
					'<img src="/cfmx/asp/parches/images/ff.gif" style="cursor:pointer" onclick="fnOP(4,' #CAT# #PreserveSingleQuotes(IDupl)# #CAT# ');" alt="Generar Version">' #CAT# ' ' 
				end
				#CAT#
				case when u.sts = 4 then
					'<img src="/cfmx/asp/parches/images/genScriptDL.gif" style="cursor:pointer" onclick="fnOP(50,' #CAT# #PreserveSingleQuotes(IDupl)# #CAT# ');" alt="Generar Script de Creación en Base Datos">' #CAT# ' ' 
				end
				#CAT#
				case when u.sts = 4 then
					'<img src="/cfmx/asp/parches/images/genXMLDL.gif" style="cursor:pointer" onclick="fnOP(51,' #CAT# #PreserveSingleQuotes(IDupl)# #CAT# ');" alt="Generar XML de Actualización">' #CAT# ' ' 
				end
				#CAT#
				' ' as op
				
		  from DBMuploads u
			inner join DBMmodelos m
				on m.IDmod = u.IDmod
		<cfif session.dbm.uidSVN NEQ "">
		 where u.uidSVN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.dbm.uidSVN#">
		</cfif>
	<cfif isdefined("url.html")>
			and u.IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.html#">
	</cfif>
		order by 1 desc
	</cfquery>

	<cfquery name="rsREFRESH" dbtype="query">
		select count(1) as cantidad
		  from rsSQL
		 where stsP NOT IN (0,10,11,23)
	</cfquery>
	<cfif rsREFRESH.cantidad GT 0>
		<script>
		<cfif isdefined("url.html")>
			setTimeout("location.href = 'DBMuploads.cfm?html=#url.html#';", 5000);
		<cfelse>
			setTimeout("location.href = 'DBMuploads.cfm';", 5000);
		</cfif>
		</script>
	</cfif>

	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		query="#rsSQL#"
		desplegar="op, IDupl, modelo, des, fec, status, prc, tabs, msg #LvarUID#"
		etiquetas="OP, UPLOAD, MODULO, DESCRIPCION, FECHA, STATUS, AVANCE<BR>%, TABLAS, MSG #LvarUIDT#"
		formatos="S,S,S,S,DT,S,M,I,S,S"
		align="left,left,left,left,left,Left,center,left,left,left"
		ajustar="N,N,N,N,N,N,N,N,S,N"
		form_method="post"
		showEmptyListMsg="yes"
		showLink = "no"
		incluyeForm = "no"
		pageindex="1"
		usaajax="no"
	/>
	<script language="javascript">
		function fnOP(op,id)
		{
			if (op == 1)
			{
				if (!confirm('¿Desea eliminar el upload ' + id +'?'))
					return;
			}
			location.href = "DBMuploads_sql.cfm?op="+op+"&id="+id
		}
		function Key(evt)
		 {
			if (!evt) evt = window.Event;
			if ("keyup,keydown".indexOf(evt.type) != -1)
				// Eventos del Teclado: keyup,keydown
				return evt.which ? evt.which : evt.keyCode;	
			else if (evt.type == "keypress")
			{
				// Eventos del Teclado: keypress
				if (window.Event) return (evt.charCode == 0 && evt.keyCode < 32) ? evt.keyCode : evt.charCode;
				return evt.charCode ? evt.charCode : evt.keyCode;	
			}
			else if ("click,mousedown,mouseup,mouseover,mousemove,mouseup".indexOf(evt.type) != -1)
				// Eventos del Mouse: 1=left, 2=center, 3=right
				return evt.button;
			else
				return -1;
		}
	</script>
	<cfif isdefined("url.html")>
		<cfquery name="rsSQL" datasource="asp">
			select html,sts,stsP
			  from DBMuploads u
			 where IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.html#">
		</cfquery>
		<cfoutput>
			<img src="/cfmx/asp/parches/images/ok16.png" onclick="sbIrVerificar()" style="cursor:pointer;"/>
			<a href="javascript:sbIrVerificar()">
			Verficar la Integridad de Base de Datos
			</a><BR /><br>
			<script>
				function sbIrVerificar()
				{
					popUpWindow_1("DBMintegrity.cfm?UPLOAD=#url.html#",0,0,1200,"100%");
				}
				
				var popUpWin=null;
				function popUpWindow_1(URLStr, left, top, width, height){
				  if(popUpWin){
					if(!popUpWin.closed)
						popUpWin.close();
				  }
				  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+(screen.width-50)+',height='+(screen.height-150)+',left=10, top=10');
				}
			</script>

			<cfif rsSQL.stsP EQ "11">
			<input type="button" value="ACEPTAR CAMBIOS" onclick="location.href = 'DBMuploads_sql.cfm?op=11&id=#url.html#'">
			</cfif>
			<input type="button" value="Ir a lista" onclick="location.href = 'DBMuploads_sql.cfm'">
			<BR>
			#rsSQL.html#
		</cfoutput>
	</cfif>
<cf_web_portlet_end>
