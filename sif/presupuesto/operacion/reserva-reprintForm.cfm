<!--- 
	Creado por: Maria de los Angeles Blanco López
		Fecha: 18 Agosto 2011
 --->

<cf_templateheader title="Reimpresipon de Suficiencias">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reimpresión de Suficiencias'>

<cfquery datasource="#session.dsn#" name="rsCentrosFun">
	select CFid, CFcodigo, CFdescripcion 
	from CFuncional CF
	inner join CPDocumentoE  DP on CF.CFid = DP.CFidOrigen
</cfquery>

<cfquery datasource="#session.dsn#" name="rsMoneda">
	select Mcodigo, Mnombre 
	from Monedas 
	where Ecodigo = #Session.Ecodigo#
</cfquery>


<cfoutput>
<form name="form1" method="post" action="reserva-reprintForm.cfm">
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td valign="top">
				<table  width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
										<td align="right"><strong>Fecha&nbsp;Desde:</strong></td>
						<td >
							<cfif isdefined("form.FechaI") and len(trim(form.FechaI))>
								<cf_sifcalendario form="form1" value="#form.FechaI#" name="FechaI" tabindex="1"> 
							<cfelse>	
								<cfset LvarFecha = createdate(year(now()),month(now()),1)>
								<cf_sifcalendario form="form1" value="#DateFormat(LvarFecha, 'dd/mm/yyyy')#" name="FechaI" tabindex="1"> 
							</cfif>
						</td>
						<td align="right"><strong>Fecha Hasta:</strong></td>
						<td>
							<cfif isdefined("form.FechaF") and len(trim(form.FechaF))>
								<cf_sifcalendario form="form1" value="#form.FechaF#" name="FechaF" tabindex="1"> 
							<cfelse>
								<cf_sifcalendario form="form1" value="#DateFormat(Now(),'dd/mm/yyyy')#" name="FechaF" tabindex="1"> 
							</cfif>
						</td>
					</tr>
					<tr>
					<td align="right"><strong>Centro Funcional:</strong></td>
					<td>

					<cf_conlis
					Campos="CFid, CFcodigo, CFdescripcion"
					Desplegables="N,S,S"
					Modificables="N,S,N"
					Size="0,10,40"
					tabindex="2"
					Title="Lista de Centros Funcionales"
				    Tabla= "CFuncional"
					Columnas="CFid, CFcodigo, CFdescripcion"
					Filtro="Ecodigo = #Session.Ecodigo#" 
					Desplegar="CFcodigo, CFdescripcion"
				    Etiquetas="Codigo, Descripción"
					filtrar_por="CFcodigo, CFdescripcion"
					Formatos="S,S"
					Align="left,left"
					form="form1"
					Asignar="CFid,CFcodigo, CFdescripcion" 
					Asignarformatos="S,S,S"
					showEmptyListMsg="true"
					EmptyListMsg="-- No se encontrarón Centros Funcionales --"></td>
					
					<td align="right"><strong>Num Documento:</strong></td>
					<td><input type="text" name="NumDoc" value=" "/></td>				
				</tr>
				
				<tr>
					<td align="right"><strong>Moneda:</strong></td>
					<td>
		           		<select name="fltMoneda"> 
	            		<option value="-1" selected="selected">(Todos)</option>
    	        		<cfloop query="rsMoneda">
        	        		<option value="#rsMoneda.Mcodigo#" <cfif isdefined("form.fltMoneda") and trim(form.fltMoneda) EQ trim(rsMoneda.Mcodigo)>selected="selected"</cfif>>#rsMoneda.Mnombre#</option>
            			</cfloop>
            			</select>
           			 </td>
				</tr>
				</table>
					
				<table width="100%" cellpadding="2" cellspacing="0" border="0">	
					<tr>
						<td  align="center"><cf_botones values="Filtrar" names="Filtrar" tabindex="2"></td>				
					</tr>
												
				<tr>
    			<td colspan="8">
					<cfquery name="rsLista" datasource="#session.dsn#">
						select 	CPPid, CPCano, CPCmes, convert(varchar(10),CPDEfechaDocumento,103) as CPDEfechaDocumento, 			                        CPDEid,	CPDEtipoDocumento, CPDEsuficiencia, CPDEnumeroDocumento, CPDEreferencia, CPDEdescripcion, 
						CFidOrigen, e.Usucodigo, cf.CFcodigo, cf.CFdescripcion, cf.CFpath,
						CPDEenAprobacion, CPDEaplicado, CPDErechazado, CPDEmsgRechazo, NAP, NRP, 
						e.Mcodigo, Miso4217, CPDEtc,
						convert(dec(15,2),(select sum(CPDDmontoOri) from CPDocumentoD where CPDEid=e.CPDEid)) as MontoOri,
						convert(dec(15,2),(select sum(CPDDmonto) from CPDocumentoD where CPDEid=e.CPDEid)) as Monto,
						u.Usulogin			
	 					from CPDocumentoE e
	  					inner join CFuncional cf on cf.CFid = e.CFidOrigen
						inner join Monedas m on m.Mcodigo = e.Mcodigo
						inner join Usuario u  on u.Usucodigo = e.Usucodigo
						where  1=1
						and CPDEtipoDocumento = 'R'
						and CPDEaplicado = 1
						<cfif isdefined("form.FechaI") and len(trim(form.FechaI)) and isdefined("form.FechaF") and len(trim(form.FechaF))>
							and CPDEfechaDocumento between convert(datetime,'#form.FechaI#',103) and convert(datetime,'#form.FechaF#',103)
						</cfif>
						<cfif isdefined("form.CFid") and len(trim(form.CFid))>
							and CFidOrigen = #form.CFid#
						</cfif>
						<cfif isdefined("form.NumDoc") and len(trim(form.NumDoc))>
							and CPDEnumeroDocumento = ltrim(rtrim(#form.NumDoc#))
						</cfif>
						<cfif isdefined("form.fltMoneda") and form.fltMoneda NEQ -1>
							and e.Mcodigo = #form.fltMoneda#
						</cfif>						
                  </cfquery>
			</td>
    		</tr>
			</table>				
		</td>	
		</tr>
	</table>
	</form>
	
	   <cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="cortes" value=""/>
			<cfinvokeargument name="desplegar" value="CPCano,CPCmes,CPDEfechaDocumento,CPDEnumeroDocumento,  CPDEdescripcion, CFcodigo,Miso4217, MontoOri, Monto"/>
			<cfinvokeargument name="etiquetas" value="Año, Mes, Fecha, NumDocumento, Descripcion, CentroFun, Moneda, MontoOrigen, MontoLocal"/>
			<cfinvokeargument name="formatos" value="S,S,I,S,S,S,S,I,i"/>
			<cfinvokeargument name="ajustar" value="N,N,N,N,S,N,N,N,N"/>
			<cfinvokeargument name="align" value="center,center, center, center, left,center,center,right, right"/>
			<cfinvokeargument name="checkboxes" value=""/>
			<cfinvokeargument name="irA" value="reserva-print.cfm"/>   
            <cfinvokeargument name="MaxRows" value="20"/>
			<cfinvokeargument name="showLink" value="true"/>
			<cfinvokeargument name="keys" value="CPDEid"/>
			<cfinvokeargument name="botones" value=""/>
            <cfinvokeargument name="navegacion" value=""/>
		</cfinvoke>


</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form = 'form1'>
<cfset session.ListaReg = "">
