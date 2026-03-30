	<cfinclude template="../../Utiles/sifConcat.cfm">
	
	<cfif isdefined("url.btnFiltrar")>
		<cfparam name="Form.btnFiltrar" default="1">
	</cfif>
	<cfif isdefined("url.CPPid") and Len(Trim(url.CPPid))>
		<cfparam name="Form.CPPid" default="#Url.CPPid#">
	<cfelse>
		<cfparam name="Form.CPPid" default="-1">
	</cfif>
	<cfif isdefined("url.CPNAPnumD") and Len(Trim(url.CPNAPnumD))>
		<cfparam name="Form.CPNAPnumD" default="#Url.CPNAPnumD#">
	</cfif>
	<cfif isdefined("url.CPNAPnumH") and Len(Trim(url.CPNAPnumH))>
		<cfparam name="Form.CPNAPnumH" default="#Url.CPNAPnumH#">
	</cfif>
	<cfif isdefined("url.FechaNapD") and Len(Trim(url.FechaNapD))>
		<cfparam name="Form.FechaNapD" default="#Url.FechaNapD#">
	</cfif>
	<cfif isdefined("url.FechaNapH") and Len(Trim(url.FechaNapH))>
		<cfparam name="Form.FechaNapH" default="#Url.FechaNapH#">
	</cfif>
	
	<cfif isdefined("url.LModulos") and Len(Trim(url.LModulos))>
		<cfparam name="Form.LModulos" default="#Url.LModulos#">
	</cfif>
	<cfif isdefined("url.CPNAPdocumentoOri") and Len(Trim(url.CPNAPdocumentoOri))>
		<cfparam name="Form.CPNAPdocumentoOri" default="#Url.CPNAPdocumentoOri#">
	</cfif>
	<cfif isdefined("url.CPNAPreferenciaOri") and Len(Trim(url.CPNAPreferenciaOri))>
		<cfparam name="Form.CPNAPreferenciaOri" default="#Url.CPNAPreferenciaOri#">
	</cfif>
	<cfif isdefined("url.FechaOriD") and Len(Trim(url.FechaOriD))>
		<cfparam name="Form.FechaOriD" default="#Url.FechaOriD#">
	</cfif>
	<cfif isdefined("url.FechaOriH") and Len(Trim(url.FechaOriH))>
		<cfparam name="Form.FechaOriH" default="#Url.FechaOriH#">
	</cfif>
	
	<cfset navegacion = "&btnFiltrar=1">
	
	<cfif isdefined("form.CPPid") and Len(Trim(form.CPPid))>
		<cfset navegacion = navegacion & "&CPPid=" & form.CPPid>
	</cfif>
	<cfif isdefined("form.CPNAPnumD") and Len(Trim(form.CPNAPnumD))>
		<cfset navegacion = navegacion & "&CPNAPnumD=" & form.CPNAPnumD>
	</cfif>
	<cfif isdefined("form.CPNAPnumH") and Len(Trim(form.CPNAPnumH))>
		<cfset navegacion = navegacion & "&CPNAPnumH=" & form.CPNAPnumH>
	</cfif>
	<cfif isdefined("form.FechaNapD") and Len(Trim(Form.FechaNapD))>
		<cfset navegacion = navegacion & "&FechaNapD=" & form.FechaNapD>
	</cfif>
	<cfif isdefined("form.FechaNapH") and Len(Trim(form.FechaNapH))>
		<cfset navegacion = navegacion & "&FechaNapH=" & Form.FechaNapH>
	</cfif>
	
	<cfif isdefined("form.LModulos") and Len(Trim(form.LModulos))>
		<cfset navegacion = navegacion & "&LModulos=" & form.LModulos>
	</cfif>
	<cfif isdefined("form.CPNAPdocumentoOri") and Len(Trim(form.CPNAPdocumentoOri))>
		<cfset navegacion = navegacion & "&CPNAPdocumentoOri=" & form.CPNAPdocumentoOri>
	</cfif>
	<cfif isdefined("form.CPNAPreferenciaOri") and Len(Trim(form.CPNAPreferenciaOri))>
		<cfset navegacion = navegacion & "&CPNAPreferenciaOri=" & form.CPNAPreferenciaOri>
	</cfif>
	<cfif isdefined("form.FechaOriD") and Len(Trim(Form.FechaOriD))>
		<cfset navegacion = navegacion & "&FechaOriD=" & form.FechaOriD>
	</cfif>
	<cfif isdefined("form.FechaOriH") and Len(Trim(form.FechaOriH))>
		<cfset navegacion = navegacion & "&FechaOriH=" & Form.FechaOriH>
	</cfif>
	
	<!--- Necesario para la pantalla de consulta de presupuesto --->
	<cfif isdefined("Form.CPNAPDlinea") and Len(Trim(Form.CPNAPDlinea))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "CPNAPDlinea=" & Form.CPNAPDlinea>
	</cfif>
	
	<cf_web_portlet_start titulo="Búsqueda de Autorizaciones Presupuestarias" width="98%">
	<cfoutput>	
	<form name="form1"style="margin:0;" method="post" action="congelarNAP.cfm">
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
					<strong>Desde NAP:</strong>&nbsp;
				</td>
				<td nowrap>
					<input 	name="CPNAPnumD" id="CPNAPnumD" size="15"
							value="<cfif isdefined('form.CPNAPnumD')>#form.CPNAPnumD#</cfif>">
				</td>
				<td nowrap align="right">
					 <strong>Hasta NAP:</strong>&nbsp;
				</td>
				<td nowrap>
					<input 	name="CPNAPnumH" id="CPNAPnumH" size="15"
							value="<cfif isdefined('form.CPNAPnumH')>#form.CPNAPnumH#</cfif>">
				</td>
				<td nowrap align="right">
					<strong>Documento:</strong>&nbsp;
				</td>
				<td nowrap>
					<input 	name="CPNAPdocumentoOri" id="CPNAPdocumentoOri" size="15"
							value="<cfif isdefined('form.CPNAPdocumentoOri')>#form.CPNAPdocumentoOri#</cfif>">
				</td>
				<td nowrap align="right">
					<strong>Referencia:</strong>&nbsp;
				</td>
				<td nowrap>
					<input 	name="CPNAPreferenciaOri" id="CPNAPreferenciaOri" size="15" 
							value="<cfif isdefined('form.CPNAPreferenciaOri')>#form.CPNAPreferenciaOri#</cfif>">	      
				</td>
			</tr>
			<tr>
				<td nowrap align="right">
					<strong>Desde Fecha NAP:</strong>&nbsp;
				</td>
				<td nowrap>
					<cfif isdefined('form.FechaNapD')>
						<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaNapD" value="#form.FechaNapD#">
					<cfelse>
						<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaNapD" value="">
					</cfif>
				</td>
				<td nowrap align="right">
					<strong>Hasta Fecha:</strong>&nbsp;
				</td>
				<td nowrap>
					<cfif isdefined('form.FechaNapH')>
						<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaNapH" value="#form.FechaNapH#">
					<cfelse>
						<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaNapH" value="">
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
	
	<cfif isdefined("form.btnFiltrar")>
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
					a.CPNAPnum, 
					a.CPNAPmoduloOri,
					a.CPNAPdocumentoOri,
					a.CPNAPreferenciaOri,
					a.CPNAPfechaOri, 
					a.CPNAPfecha, 
					coalesce(
						(
							select sum(CPNAPDmonto)
							  from CPNAPdetalle d
							 where d.Ecodigo	= a.Ecodigo
							   and d.CPNAPnum	= a.CPNAPnum
						), 0)
					as Monto,
					'&nbsp;' #_Cat# rtrim(b.Pnombre) #_Cat# ' ' #_Cat# rtrim(b.Papellido1) #_Cat# ' ' #_Cat# rtrim(b.Papellido2) as NombreAutoriza,
					'<input type="checkbox" style="cursor:pointer;" value="' 
							#_Cat# <cf_dbfunction name="to_char" args="CPNAPnum"> #_Cat# '" '
							#_Cat# case when CPNAPcongelado = 1 then 'checked ' end
							#_Cat# 'onclick="sbCongelar(this);">' 
					as chk
			from CPNAP a	
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
			<cfif isdefined("form.CPNAPnumD") and len(trim(form.CPNAPnumD))>
				and a.CPNAPnum >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPNAPnumD#">
			</cfif>
			<cfif isdefined("form.CPNAPnumH") and len(trim(form.CPNAPnumH))>
				and a.CPNAPnum <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPNAPnumH#">
			</cfif>
			and a.CPNAPnumModificado is null
			<cfif isdefined("form.FechaNapD") and len(trim(form.FechaNapD))>
				and a.CPNAPfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaNapD)#">
			</cfif>
			<cfif isdefined("form.FechaNapH") and len(trim(form.FechaNapH))>
				and a.CPNAPfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,LSParseDateTime(form.FechaNapH))#">
			</cfif>
	
			<cfif isdefined("form.LModulos") and len(trim(form.LModulos)) >			
				and a.CPNAPmoduloOri = <cfqueryparam cfsqltype="cf_sql_char" value="#form.LModulos#">
			</cfif>
			<cfif isdefined("form.CPNAPdocumentoOri") and len(trim(form.CPNAPdocumentoOri))>
				and a.CPNAPdocumentoOri like <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CPNAPdocumentoOri#%">
			</cfif>
			<cfif isdefined("form.CPNAPreferenciaOri") and len(trim(form.CPNAPreferenciaOri))>
				and a.CPNAPreferenciaOri like <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CPNAPreferenciaOri#%">
			</cfif>
			<cfif isdefined("form.FechaOriD") and len(trim(form.FechaOriD))>
				and a.CPNAPfechaOri >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaOriD)#">
			</cfif>
			<cfif isdefined("form.FechaOriH") and len(trim(form.FechaOriH))>
				and a.CPNAPfechaOri <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,LSParseDateTime(form.FechaOriH))#">
			</cfif>
			
			order by Pdescripcion, a.CPNAPfecha, a.CPNAPnum
		</cfquery>
		<script language="javascript">
			function sbCongelar(obj)
			{
				var NAP = obj.value;
				var OP = obj.checked ? "1" : "0";
				document.getElementById ("ifrSQL").src = "congelarNAP-sql.cfm?Ecodigo=<cfoutput>#session.Ecodigo#</cfoutput>&NAP=" + NAP + "&OP=" + OP;
			}
		</script>
		<iframe id="ifrSQL" style="display:none" frameborder="1">
		</iframe>
		<table width="98%" align="center" >
		<tr><td>
		<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="chk, CPNAPnum, CPNAPmoduloOri, CPNAPdocumentoOri, CPNAPreferenciaOri, CPNAPfechaOri, CPNAPfecha, monto, NombreAutoriza"/>
				<cfinvokeargument name="etiquetas" value="CONGELAR, NAP, Modulo, Documento, Referencia, Fecha<BR>Documento, Fecha<BR>Autorizacion, Monto<BR>Autorizado, &nbsp;Autorizado por"/>
				<cfinvokeargument name="cortes" value="Pdescripcion"/>
				<cfinvokeargument name="formatos" value="S,V,S,S,S,D,D,M,V"/>
				<cfinvokeargument name="align" value="center,right,center,left,left,center,center,right,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
				<cfinvokeargument name="keys" value="CPNAPnum">
				<cfinvokeargument name="MaxRows" value="20"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="showLink" value="false"/>
				<cfinvokeargument name="PageIndex" value="3"/>		
		</cfinvoke>	
		</td></tr>
		</table>
	</cfif>	
	<cf_web_portlet_end><br>
	
