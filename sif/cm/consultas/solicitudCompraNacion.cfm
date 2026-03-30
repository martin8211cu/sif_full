<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfinclude template="../../Utiles/sifConcat.cfm">
<cf_templatecss>
<style type="text/css">
	.LetraDetalle{
		font-size:10px;
	}
	.LetraEncab{
		font-size:10px;
		font-weight:bold;
	}
.TituloPrincipal {
	font-size: 21px;
	font-style: italic;
	font-weight: bold;
}
.NumeroSol {
	font-size: 18px;
	font-weight: bold;
	font-style: italic;
}
</style>
	
<cfset max_lineas = 18 * 1.0>

<cfif isdefined ("url.ESnumero") and len(trim(url.ESnumero)) and not isdefined ("form.ESnumero")>
	<cfset form.ESnumero = url.ESnumero>
</cfif>
<cfif isdefined ("url.CMSid") and len(trim(url.CMSid)) and not isdefined ("form.CMSid")>
	<cfset form.CMSid = url.CMSid>
</cfif>
<cfif isdefined ("url.ESidsolicitud") and len(trim(url.ESidsolicitud)) and not isdefined ("form.ESidsolicitud")>
	<cfset form.ESidsolicitud = url.ESidsolicitud>
</cfif>

<cfquery name="rsSolicitud" datasource="#session.DSN#">
	select 	em.Edescripcion,
			b.DSconsecutivo,      		
			b.DSmontoest,
			b.DStotallinest,  
			b.DScant,
			b.Ucodigo,			
			(coalesce(b.DSdescalterna,' -- ') #_Cat# ' / ' #_Cat# coalesce(b.DSobservacion,' -- ')) as  detalle,
			b.DSdescripcion,
			b.DSespecificacuenta,
			b.DSformatocuenta,
			b.DSobservacion,
			<!---c.Adescripcion, --->
			a.ESfecha,
            a.ESfechaAplica,
			a.ESnumero,
			a.EStotalest,
			a.Usucodigo,
			em.ETelefono1,                   
			em.ETelefono2,             
			em.EDireccion1,         
			em.EDireccion2,             
			em.EDireccion3,     
			em.EIdentificacion as iden,
            sol.CMSnombre as solicitante,
            cf.CFcodigo,
            cf.CFdescripcion,            
            coalesce(j.Acodigo,'--')#_Cat# ' - ' #_Cat# coalesce(j.Acodalterno, '--') as Adescripcion,
			rtrim(ltrim(e.CMTScodigo)) #_Cat#'-'#_Cat# rtrim(ltrim(e.CMTSdescripcion)) as tipo,
			al.Almcodigo,
			case DStipo when 'A' then coalesce(c.Acodigo,'') 
						when 'S' then coalesce(k.Ccodigo,'')
						when 'F' then coalesce(ac.ACcodigodesc,'') 
			end as codigo,
			b.DSformatocuenta,
			rtrim(ltrim(d.CFcodigo)) #_Cat#'-'#_Cat# rtrim(ltrim(d.CFdescripcion)) as CFuncional,
			a.ESobservacion,
			a.SNcodigo, 
			p.NumeroParte,
			a.ESestado,
			case when a.ESestado = 0 then  'Pendiente' 
				when a.ESestado = 10 then 'En Trámite Aprobación'
				when a.ESestado = -10 then  'Rechazada por presupuesto'
				when a.ESestado = 20 then 'Aplicada'
				when a.ESestado = 25 then  'Compra Directa'
				when a.ESestado = 40 then 'Parcialmente Surtida'
				when a.ESestado = 50 then  'Surtida'
				when a.ESestado = 60 then  'Cancelada' 
			end as estado,		
			cfcta.CFformato,
			cfcta.CFdescripcion,
			imp.Iporcentaje,
			a.ProcessInstanceid
	from ESolicitudCompraCM a
		LEFT OUTER JOIN CMTiposSolicitud e     
			on a.Ecodigo = e.Ecodigo
		   and a.CMTScodigo = e.CMTScodigo
		
		LEFT OUTER JOIN Monedas m    
			on m.Mcodigo = a.Mcodigo
            
        LEFT OUTER JOIN CMSolicitantes sol   
            on sol.CMSid = a.CMSid
            
        LEFT OUTER JOIN CFuncional cf
            on cf.CFid = a.CFid            
		
		LEFT OUTER JOIN Empresas em
			on a.Ecodigo = em.Ecodigo
		
		LEFT OUTER JOIN DSolicitudCompraCM b
			inner join CFuncional d
				on b.CFid = d.CFid
		
        LEFT OUTER JOIN Articulos j
				   on b.Aid=j.Aid				  
        
		LEFT OUTER JOIN Impuestos imp
				on imp.Ecodigo = b.Ecodigo
			   and imp.Icodigo = b.Icodigo
               
		LEFT OUTER JOIN Articulos c
				on c.Aid=b.Aid
		
		LEFT OUTER JOIN Almacen al
				on  al.Aid = b.Alm_Aid
			
		LEFT OUTER JOIN Conceptos k
				on b.Cid=k.Cid
		
		LEFT OUTER JOIN AClasificacion ac
				on b.Ecodigo = ac.Ecodigo
			   and b.ACcodigo = ac.ACcodigo
 			   and b.ACid = ac.ACid
			
		LEFT OUTER JOIN CFinanciera cfcta
			on b.CFcuenta = cfcta.CFcuenta
		
		on a.ESidsolicitud = b.ESidsolicitud 
		
		LEFT OUTER JOIN NumParteProveedor p
			on c.Aid = p.Aid
			and c.Ecodigo = p.Ecodigo
			and a.SNcodigo = p.SNcodigo
			and a.ESfecha between p.Vdesde and p.Vhasta
	<cfif isdefined('URL.ESidsolicitud')>
    	where a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
    <cfelse>
        where a.Ecodigo	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
          and a.ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero#">
          and a.CMSid	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMSid#">
    </cfif>
	order by a.ESnumero, b.DSconsecutivo
</cfquery>

<cfquery name="rsTotales" dbtype="query">
	select sum((Iporcentaje*DSmontoest*DScant)/100.0) as impuesto, sum(DScant*DSmontoest) as subtotal
	from rsSolicitud
</cfquery>

<!-----Nombre de la empresa ----->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion 
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfset LvarAutorizador= ''>
<!---►►Coloca el Autorizador del tramite de la SC ◄◄--->
<cfif Len(Trim(rsSolicitud.ProcessInstanceid))>  
	<cfquery name="rsParticipante" datasource="#Session.DSN#">
		select b.Description
		from WfxActivity a
			inner join WfxActivityParticipant b
				on a.ActivityInstanceId = b.ActivityInstanceId
		where a.ProcessInstanceId = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsSolicitud.ProcessInstanceid#">
		  and b.HasTransition     = 1
	</cfquery>						
	<cfloop query = "rsParticipante">
		 <cfset LvarAutorizador= rsParticipante.Description> 
	</cfloop>
</cfif> 
   
<!---►►Coloca el Autorizador al mismo Usuario de la SC◄◄--->
<cfif NOT LEN(TRIM(LvarAutorizador))>
	 <cfquery name="rsLogin" datasource="#session.DSN#">
		select a.Usulogin, b.Pnombre #_Cat#' '#_Cat# b.Papellido1 #_Cat#' '#_Cat# b.Papellido2 as nombre
		from Usuario a
			left outer join DatosPersonales b
				on a.datos_personales = b.datos_personales	
		<cfif Len(Trim(rsSolicitud.Usucodigo))>
		     where a.Usucodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsSolicitud.Usucodigo#">
		<cfelse>
			where 1 = 2
		</cfif>
	</cfquery>
	<cfif isdefined('rsLogin') and rsLogin.recordcount NEQ 0>                
		<cfset LvarAutorizador= rsLogin.nombre> 
	</cfif>
</cfif>

<cfoutput>
<cfsavecontent variable="encabezado">
	<table width="98%" border="0" cellpadding="0"  cellspacing="0" align="center">
		<tr>
            <td align="center" colspan="2">			
		    </td>
        </tr>
		<tr>
            <td align="center" bgcolor="##CCCCCC" colspan="2">
            </td>
        </tr>		
		<tr>
            <td colspan="2">&nbsp;
            </td>
        </tr>		
		<cfif rsSolicitud.RecordCount EQ 0>					
			<tr>
			  <td align="left" colspan="2"><strong><font class="TituloPrincipal">Solicitud De Materiales</font></strong></td></tr>
	    <tr>
			  <td align="left" colspan="2"><strong><font size="2"> Número de Solicitud: #form.ESnumero#</font></strong></td></tr>
			<tr><td align="center" colspan="2">-------------------   No se encontraron registros   -------------------</td></tr>
		<cfelse>		
		<tr>
            <td align="left" colspan="2"><strong><font class="TituloPrincipal">Solicitud De Materiales</font></strong>
            </td>
        </tr>
		<tr>
           <td width="50%" ><strong>N&uacute;mero de Solicitud :</strong><font class="NumeroSol" > #rsSolicitud.ESnumero#</font>
          </td>
           <td width="50%" >
               <strong>Solicitante:</strong><font size="3"> #rsSolicitud.solicitante#</font>
          </td>
        </tr>
        <tr>
           <td width="50%" ><strong>Fecha Emisi&oacute;n:</strong><font size="3"> #LSDateFormat(rsSolicitud.ESfecha,'dd/mm/yyyy')#</font>
           </td>
           <td width="50%" >
               <strong>Departamento:</strong> <font size="3"> #rsSolicitud.CFcodigo#-#rsSolicitud.CFdescripcion#</font>
           </td>
        </tr>
          <tr>
           <td width="50%" ><strong>Fecha Autorizaci&oacute;n:</strong><font size="3"> #LSDateFormat(rsSolicitud.ESfechaAplica,'dd/mm/yyyy')#</font>
           </td>
           <td width="50%" >
               <strong>Autorizador: </strong><font size="3"> #LvarAutorizador#</font>
           </td>
        </tr>        
         <tr>
           <td width="50%" ><strong>Empresa:</strong><font size="3"> #rsEmpresa.Edescripcion #</font>
           </td>
           <td width="50%" >&nbsp;            
           </td>
        </tr>
		<tr>
			<td colspan="2"><strong>Observaciones:</strong><font size="3">&nbsp;#rsSolicitud.ESobservacion#</font>
            </td>
        </tr>
        <tr>
            <td colspan="2">&nbsp;</td>
		</tr>
		</cfif>	
	</table>
</cfsavecontent>

	<cfif rsSolicitud.RecordCount NEQ 0>
		<cfset contador = 0 >
		<!---
		<cfset vnTotalEstimado = 0>
		--->
		<table width="98%" border="0" cellpadding="2" cellspacing="0" align="center">
			<!--- Primer Loop para pintar las líneas de solicitud --->
			 <cfloop query="rsSolicitud">
				<cfif (isdefined("Url.imprimir") and contador eq max_lineas) or rsSolicitud.Currentrow eq 1>	  			  
					<tr><td colspan="7">
						#encabezado#
					</td></tr>
                     <tr>
                      <td colspan="8">
                       <hr />
                      </td>
                    <tr>  
					<tr>
						<td class="LetraEncab">L&iacute;n.</td>
						<td class="LetraEncab">Artículo</td>
						<td class="LetraEncab">Descripción</td>
						<td class="LetraEncab">Descripción Detallada</td>
						<td class="LetraEncab">Cantidad</td>
						<td class="LetraEncab">U. Medida.</td>
						<td class="LetraEncab">Cuenta Contable</td>	
						<td class="LetraEncab">Desc. Cuenta</td>			
					</tr>
                    <tr>
                      <td colspan="8">
                       <hr />
                      </td>
                    <tr>   	
				<cfset contador = 0 >
				</cfif>
				  <tr>
					<td  class="LetraDetalle">#rsSolicitud.DSconsecutivo#&nbsp;</td>
					<td  class="LetraDetalle">#rsSolicitud.Adescripcion#&nbsp;</td>
					<td  class="LetraDetalle">#rsSolicitud.DSdescripcion#&nbsp;</td>
					<td  class="LetraDetalle">#rsSolicitud.detalle#&nbsp;</td>
					<td  class="LetraDetalle">#rsSolicitud.DScant#&nbsp;</td>
					<td  class="LetraDetalle">#rsSolicitud.Ucodigo#&nbsp;</td>
                    <td  class="LetraDetalle">
						<cfif rsSolicitud.DSespecificacuenta EQ 1>
							#rsSolicitud.DSformatocuenta#
						<cfelseif rsSolicitud.DSespecificacuenta EQ 0>
							#rsSolicitud.CFformato#
						</cfif>
						&nbsp;
					</td>        
					<td class="LetraDetalle">#rsSolicitud.CFdescripcion#&nbsp;</td>          
				</tr>

				<cfif isdefined("Url.imprimir") and rsSolicitud.Currentrow mod max_lineas EQ 0> 
					  <tr>
						<td colspan="11" align="right" class="LetraDetalle">Pág. #Int(rsSolicitud.Currentrow / max_lineas)#/#Ceiling((rsSolicitud.recordCount * 2) / max_lineas)#</td>
					  </tr>			  
				</cfif>
				
				<cfset contador = contador + 1 >
				<!---
				<cfset vnTotalEstimado = vnTotalEstimado + rsSolicitud.DStotallinest>
				--->
			 </cfloop>

			 <cfset contador = rsSolicitud.recordCount>
			 
			 <!--- Segundo Loop para pintar las descripciones y observaciones de las líneas de solicitud --->
			 <cfloop query="rsSolicitud">
				<cfif (isdefined("Url.imprimir") and contador eq max_lineas)>
					<cfset contador = 0 >
				</cfif>			
				<cfif isdefined("Url.imprimir") and (rsSolicitud.recordCount + rsSolicitud.Currentrow) NEQ (rsSolicitud.recordCount * 2) and (rsSolicitud.recordCount + rsSolicitud.Currentrow) mod max_lineas EQ 0> 
					  <tr>
						<td colspan="11" align="right" class="LetraDetalle">Pág. #Int((rsSolicitud.recordCount + rsSolicitud.Currentrow) / max_lineas)#/#Ceiling((rsSolicitud.recordCount * 2) / max_lineas)#</td>
					  </tr>			  
				</cfif>

				<cfset contador = contador + 1 >
			 </cfloop>

			 <cfif rsSolicitud.recordCount>
			 </cfif>
			
			<tr>
				<td colspan="11"><table><tr>
				<td class="LetraEncab"><!---Observaciones:---></td>
				<td colspan="10" class="LetraDetalle"><!---#rsSolicitud.ESobservacion#---></td>
				</tr></table></td>
			</tr>			
			<tr>
				<td colspan="11"><table><tr>
					<!--- Obtiene el login y el nombre del Usucodigo de la tabla ESolicitudCompraCM ----->
					<!---<cfquery name="rsLogin" datasource="#session.DSN#">
						select a.Usulogin, b.Pnombre #_Cat#' '#_Cat# b.Papellido1 #_Cat#' '#_Cat# b.Papellido2 as nombre
						from Usuario a
							left outer join DatosPersonales b
								on a.datos_personales = b.datos_personales	
						where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitud.Usucodigo#">
					</cfquery>--->
					<td nowrap valign="top" class="LetraEncab">
						<!---Usuario que aplicó:--->
					</td>				
					<td colspan="10" valign="top" class="LetraDetalle">
						<!---<cfif rsLogin.RecordCount NEQ 0>&nbsp;#rsLogin.nombre#&nbsp;</cfif>--->
					</td>
				</tr></table></td>
			</tr>
			<tr>
				<td colspan="11"><table><tr>
					<td nowrap valign="top" class="LetraEncab">
						<!--- Obtiene el Nombre del usuario que aprobó 
						Usuario que aprob&oacute;:--->
					</td>
					<td colspan="10" valign="top" class="LetraDetalle">
					<!---	<cfif Len(Trim(rsSolicitud.ProcessInstanceid))>  
							<cfquery name="rsParticipante" datasource="#Session.DSN#">
								select b.Description
								from WfxActivity a, WfxActivityParticipant b
								where a.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitud.ProcessInstanceid#">
								and a.ActivityInstanceId = b.ActivityInstanceId
								and b.HasTransition = 1
							</cfquery>						
							<cfif rsParticipante.recordCount>
								<cfloop query = "rsParticipante">
									&nbsp;#rsParticipante.Description#&nbsp;<br>
								</cfloop>
							<cfelse>
								<cfif rsLogin.RecordCount NEQ 0>
									&nbsp;#rsLogin.nombre#&nbsp;
								</cfif>
							</cfif>
						<cfelse>
							<cfif rsLogin.RecordCount NEQ 0>
								&nbsp;#rsLogin.nombre#&nbsp;
							</cfif>
						</cfif>--->
					</td>
				</tr></table></td>
			</tr>			

			<cfif isdefined("Url.imprimir") and rsSolicitud.recordCount>
			<tr>
				<td height="44" colspan="11" align="right" class="LetraDetalle">
					Pág. #Ceiling((rsSolicitud.recordCount * 2) / max_lineas)#/#Ceiling((rsSolicitud.recordCount * 2) / max_lineas)#
				</td>
			</tr>
			</cfif>
			
			</table>
  </cfif>	
</cfoutput>