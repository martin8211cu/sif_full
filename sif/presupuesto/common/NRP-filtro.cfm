<cf_navegacion name="CPPid"			default="-1"	session	navegacion = "navegacion">
<cf_navegacion name="CPNRPnumD"		default=""		session	navegacion = "navegacion">
<cf_navegacion name="CPNRPnumH"		default=""		session	navegacion = "navegacion">
<cf_navegacion name="FechaNRPD"		default=""		session	navegacion = "navegacion">
<cf_navegacion name="FechaNRPH"		default=""		session	navegacion = "navegacion">
<cf_navegacion name="LModulos"		default=""		session	navegacion = "navegacion">
<cf_navegacion name="DocumentoOri"	default=""		session	navegacion = "navegacion">
<cf_navegacion name="ReferenciaOri"	default=""		session	navegacion = "navegacion">
<cf_navegacion name="FechaOriD"		default=""		session	navegacion = "navegacion">
<cf_navegacion name="FechaOriH"		default=""		session	navegacion = "navegacion">

<cf_navegacion name="btnFiltrar"	default=""		session	navegacion = "navegacion">

<cfinclude template="../../Utiles/sifConcat.cfm">
<!--- Necesario para la pantalla de consulta de presupuesto --->
<cfif isdefined("Form.CPNRPDlinea") and Len(Trim(Form.CPNRPDlinea))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "CPNRPDlinea=" & Form.CPNRPDlinea>
</cfif>

<cfif isdefined("LvarTrasladosNRP")>
	<cfset LvarAprobacionNRP = true>
</cfif>

<cfif isdefined("LvarAprobacionNRP")>
	<cfset LvarTipo = " sin Aprobar">
<cfelseif isdefined("LvarCancelacionNRP")>
	<cfset LvarTipo = " Aprobados sin Aplicar">
<cfelse>
	<cfset LvarTipo = "">
</cfif>

<cf_web_portlet_start titulo="Búsqueda de Rechazos Presupuestarios#LvarTipo#" width="98%">
<cfoutput>	
<form name="form1"style="margin:0;" method="post" action="<cfif isdefined("LvarTrasladosNRP")>trasladosNRP.cfm<cfelseif isdefined("LvarAprobacionNRP")>autorizacionNRP.cfm<cfelseif isdefined("LvarCancelacionNRP")>cancelacionNRP.cfm<cfelse>ConsNRP.cfm</cfif>">
	<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0" class="areaFiltro">        
		<tr>
			<td nowrap align="right">
				<strong>Período:</strong>&nbsp;
			</td>
			<td colspan="3">
				<cf_cboCPPid incluirTodos="true" value="#form.CPPid#" CPPestado="1,2">
			</td>
			<td nowrap align="right">
				<strong>Módulo:</strong>&nbsp;
			</td>
			<td nowrap colspan="3">
				<cfquery name="rsModulos" datasource="#Session.DSN#">
					select Oorigen,Odescripcion from Origenes
				</cfquery>
				<select name="LModulos" id="select">
					<option value="" selected>(Todos los Módulos...)</option>
				<cfloop query="rsModulos">
					<option value="#trim(rsModulos.Oorigen)#" <cfif isdefined('form.LModulos') and (trim(rsModulos.Oorigen) EQ trim(form.LModulos))>selected</cfif>>#HTMLEditFormat(rsModulos.Oorigen)# - #HTMLEditFormat(rsModulos.Odescripcion)#</option>
				</cfloop>
				</select>
			</td>		
			<td rowspan="3" align="center" width="100"> 
				<input name="btnFiltrar" type="submit" value="Buscar">
			</td>		
		</tr>
		
		<tr>
			<td nowrap align="right">
				<strong>Desde NRP:</strong>&nbsp;
			</td>
			<td nowrap>
				<input 	name="CPNRPnumD" id="CPNRPnumD" size="15"
						value="<cfif isdefined('form.CPNRPnumD')>#form.CPNRPnumD#</cfif>">
			</td>
			<td nowrap align="right">
				 <strong>Hasta NRP:</strong>&nbsp;
			</td>
			<td nowrap>
				<input 	name="CPNRPnumH" id="CPNRPnumH" size="15"
				  		value="<cfif isdefined('form.CPNRPnumH')>#form.CPNRPnumH#</cfif>">
			</td>
			<td nowrap align="right">
				<strong>Documento:</strong>&nbsp;
			</td>
			<td nowrap>
				<input 	name="DocumentoOri" id="DocumentoOri" size="15"
						value="<cfif isdefined('form.DocumentoOri')>#form.DocumentoOri#</cfif>">
			</td>
			<td nowrap align="right">
				<strong>Referencia:</strong>&nbsp;
			</td>
			<td nowrap>
				<input 	name="ReferenciaOri" id="ReferenciaOri" size="15" 
						value="<cfif isdefined('form.ReferenciaOri')>#form.ReferenciaOri#</cfif>">	      
			</td>
		</tr>
		<tr>
			<td nowrap align="right">
				<strong>Desde Fecha NRP:</strong>&nbsp;
			</td>
			<td nowrap>
				<cfif isdefined('form.FechaNRPD')>
					<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaNRPD" value="#form.FechaNRPD#">
				<cfelse>
					<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaNRPD" value="">
				</cfif>
			</td>
			<td nowrap align="right">
				<strong>Hasta Fecha:</strong>&nbsp;
			</td>
			<td nowrap>
				<cfif isdefined('form.FechaNRPH')>
					<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaNRPH" value="#form.FechaNRPH#">
				<cfelse>
					<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaNRPH" value="">
				</cfif>
			</td>
			<td nowrap align="right">
				<strong>Desde Fecha Doc:</strong>&nbsp;
			</td>
			<td nowrap>
				<cfif isdefined('form.FechaOriD')>
					<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaOriD" value="#form.FechaOriD#">
				<cfelse>
					<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaOriD" value="">
				</cfif>
			</td>
			<td nowrap align="right">
				<strong>Hasta Fecha:</strong>&nbsp;
			</td>
			<td nowrap>
				<cfif isdefined('form.FechaOriH')>
					<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaOriH" value="#form.FechaOriH#">
				<cfelse>
					<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaOriH" value="">
				</cfif>
			</td>
		</tr>
	</table>
</form>		
</cfoutput>

<cfif isdefined("form.btnFiltrar") AND form.btnFiltrar NEQ "">
	<cfquery name="rsLista" datasource="#Session.DSN#">
		select 	
				'Período de Presupuesto: ' #_Cat#
					case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
					#_Cat# ' de ' #_Cat# 
					case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
					#_Cat# ' a ' #_Cat# 
					case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
				as Pdescripcion,
				a.CPPid,
				a.CPNRPnum, 
				a.CPNRPmoduloOri,
				a.CPNRPdocumentoOri,
				a.CPNRPreferenciaOri,
			   	a.CPNRPfechaOri, 
			   	a.CPNRPfecha, 
				coalesce(
					(
						select sum(CPNRPDmonto)
						  from CPNRPdetalle d
						 where d.Ecodigo	= a.Ecodigo
						   and d.CPNRPnum	= a.CPNRPnum
					), 0)
				as Monto,
			   	'&nbsp;' #_Cat# rtrim(b.Pnombre) #_Cat# ' ' #_Cat# rtrim(b.Papellido1) #_Cat# ' ' #_Cat# rtrim(b.Papellido2) as NombreAutoriza,
				CPNRPtipoCancela,
				UsucodigoAutoriza,
				CPNAPnum
		from CPNRP a	
			inner join CPresupuestoPeriodo p
				 on p.CPPid 	= a.CPPid		
                and p.Ecodigo 	= a.Ecodigo
			left outer join Usuario c
				left outer join DatosPersonales b
					on c.datos_personales = b.datos_personales
				 on c.Usucodigo	= a.UsucodigoAutoriza
				and c.Uestado 	= 1
				and c.Utemporal	= 0
				and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		where 	a.Ecodigo =#Session.Ecodigo#      		
		<cfif isdefined("form.CPPid") and len(trim(form.CPPid)) and form.CPPid NEQ -1>
			and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
		</cfif>
		<cfif isdefined("form.CPNRPnumD") and len(trim(form.CPNRPnumD))>
			and a.CPNRPnum >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPNRPnumD#">
		</cfif>
		<cfif isdefined("form.CPNRPnumH") and len(trim(form.CPNRPnumH))>
			and a.CPNRPnum <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPNRPnumH#">
		</cfif>
		<cfif isdefined("form.FechaNRPD") and len(trim(form.FechaNRPD))>
			and a.CPNRPfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaNRPD)#">
		</cfif>
		<cfif isdefined("form.FechaNRPH") and len(trim(form.FechaNRPH))>
			and a.CPNRPfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,LSParseDateTime(form.FechaNRPH))#">
		</cfif>

		<cfif isdefined("form.LModulos") and len(trim(form.LModulos)) >			
			and a.CPNRPmoduloOri = <cfqueryparam cfsqltype="cf_sql_char" value="#form.LModulos#">
		</cfif>
		<cfif isdefined("form.DocumentoOri") and len(trim(form.DocumentoOri))>
			and a.CPNRPdocumentoOri like <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DocumentoOri#%">
		</cfif>
		<cfif isdefined("form.ReferenciaOri") and len(trim(form.ReferenciaOri))>
			and a.CPNRPreferenciaOri like <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ReferenciaOri#%">
		</cfif>
		<cfif isdefined("form.FechaOriD") and len(trim(form.FechaOriD))>
			and a.CPNRPfechaOri >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaOriD)#">
		</cfif>
		<cfif isdefined("form.FechaOriH") and len(trim(form.FechaOriH))>
			and a.CPNRPfechaOri <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,LSParseDateTime(form.FechaOriH))#">
		</cfif>
		
		<cfif isdefined("LvarAprobacionNRP")>
			<!--- Se pueden aprobar: Sin Aprobar, Sin Aplicar, Sin Cambiar y Sin Cancelar --->
			and a.UsucodigoAutoriza is null and a.CPNAPnum is null and a.CPNRPtipoCancela = 0 <!--- and a.CPNRPcancelado = 0 --->
		<cfelseif isdefined("LvarCancelacionNRP")>
			<!--- Se pueden aprobar: Aprobados, Sin Aplicar, Sin Cambiar y Sin Cancelar --->
			and a.UsucodigoAutoriza is not null and a.CPNAPnum is null and a.CPNRPtipoCancela = 0 <!--- and a.CPNRPcancelado = 0 --->
		</cfif>		
		order by Pdescripcion desc, a.CPNRPfecha desc
	</cfquery>
	<table width="98%" align="center" >
	<tr><td>
	<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="CPNRPnum, CPNRPmoduloOri, CPNRPdocumentoOri, CPNRPreferenciaOri, CPNRPfechaOri, CPNRPfecha, monto, NombreAutoriza, CPNAPnum"/>
			<cfinvokeargument name="etiquetas" value="NRP, Modulo, Documento, Referencia, Fecha<BR>Documento, Fecha<BR>Rechazo, Monto<BR>Rechazado<BR>#LvarMnombreEmpresa#, &nbsp;Aprobado por,NAP"/>
			<cfinvokeargument name="cortes" value="Pdescripcion"/>
			<cfinvokeargument name="formatos" value="V,S,S,S,D,D,M,V,V"/>
			<cfinvokeargument name="align" value="right,center,left,left,center,center,right,left,center"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
			<cfinvokeargument name="keys" value="CPNRPnum">
			<cfinvokeargument name="MaxRows" value="20"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="PageIndex" value="3"/>		
			<cfif not isdefined("LvarAprobacionNRP") and not isdefined("LvarCancelacionNRP")>
				<cfinvokeargument name="lineaRoja" 	value="CPNRPtipoCancela NEQ 0"/>
				<cfinvokeargument name="lineaVerde" value="UsucodigoAutoriza NEQ '' AND CPNAPnum EQ ''"/>
				<cfinvokeargument name="lineaAzul" 	value="CPNAPnum NEQ ''"/>
			</cfif>
	</cfinvoke>	
	</td></tr>
	</table>
	<cfif not isdefined("LvarAprobacionNRP") and not isdefined("LvarCancelacionNRP")>
		<font color="#000000">&nbsp;&nbsp;(*) NRPs rechazos presupuestarios</font><br>
		<font color="#FF0000">&nbsp;&nbsp;(*) NRPs cancelados</font><br>
		<font color="#00CC00">&nbsp;&nbsp;(*) NRPs aprobados pendientes de aplicar</font><br>
		<font color="#0000FF">&nbsp;&nbsp;(*) NRPs aplicados</font><br>
	</cfif>
</cfif>	
<cf_web_portlet_end>
<br><br>
