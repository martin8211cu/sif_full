<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfset Title           = "Reporte Consolidado de Solictudes de Compra">
<cfset FileName        = "SolicitudCompraConso">
<cfset FileName 	   = FileName & ".xls">
<!--- <cf_templatecss> --->
<cf_htmlreportsheaders title="#Title#" filename="#FileName#" download="yes" ira="saldosSolicitudCompraConsolidado.cfm">
<style type="text/css">
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
		font-size:13px;
		background-color:#F5F5F5;
		font-family:Tahoma, Geneva, sans-serif;
	}
	.csssolicitante {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
		font-size:12px;
		background-color:#FAFAFA;
		font-family:Tahoma, Geneva, sans-serif;
	}
	.item {
		font-size:12px;
		font-family:Tahoma, Geneva, sans-serif;
	}
	.letra {
		font-size:12px;
		padding-bottom:5px;
		font-family:Tahoma, Geneva, sans-serif;
	}
	.letra2 {
		font-size:12px;
		font-weight:bold;
		font-family:Tahoma, Geneva, sans-serif;
	}
	.letra3 {
		font-size:15px;
		font-weight:bold;
		font-family:Tahoma, Geneva, sans-serif;
	}
	.letra4 {
		font-size:12px;
		font-weight:bold;
		text-align:right;
		font-family:Tahoma, Geneva, sans-serif;
	}
</style>

<cfset form.Ocodigo = "">
<cfset form.GOid = "">
<cfset form.GEid = "">
<cfset TituloUbicacion = "Oficina/Grupo">
<cfparam name="form.ubicacion" default="">
<cfif ListFirst(form.ubicacion) EQ 'of'>
	<cfset TituloUbicacion = "Oficina">
	<cfset form.Ocodigo = ListRest(form.ubicacion)>
<cfelseif ListFirst(form.ubicacion) EQ 'ge'>
	<cfset TituloUbicacion = "Grupo de Empresas">
	<cfset form.GEid = ListRest(form.ubicacion)>
<cfelseif form.ubicacion EQ '-1'>
	<cfset TituloUbicacion = "Variables de Empresa">
</cfif>
<cfif ListLen(form.ubicacion) EQ 2>
	<cfset form.AVid = ''>
</cfif>

<cfparam name="form.Ocodigo" default="">
<cfparam name="form.GOid"    default="">
<cfparam name="form.GEid"    default="">
<cfparam name="form.AVid"    default="">

<cfif isdefined("url.CMSid") and not isdefined("form.CMSid")>
	<cfset form.CMSid = Url.CMSid>
	<cfset form.CMSid = Url.CMSid>
</cfif>
<cfif isdefined("url.ESidsolicitud1") and not isdefined("form.ESidsolicitud1")>
	<cfset form.ESidsolicitud1 = Url.ESidsolicitud1>
	<cfset form.ESidsolicitud1 = Url.ESidsolicitud1>
</cfif>
<cfif isdefined("url.ESidsolicitud2") and not isdefined("form.ESidsolicitud2")>
	<cfset form.ESidsolicitud2 = Url.ESidsolicitud2>
	<cfset form.ESidsolicitud2 = Url.ESidsolicitud2>
</cfif>

<cfif isdefined("url.fechai") and len(trim(url.fechai)) and not isdefined("form.fechai")>
	<cfset form.fechai = Url.fechai>
	<cfset vFechai = lsparseDateTime(form.fechai) >
</cfif>
<cfif isdefined("url.fechaf") and len(trim(url.fechai)) and not isdefined("form.fechaf")>
	<cfset form.fechaf = Url.fechaf>
	<cfset vFechaf = lsparseDateTime(form.fechaf) >
</cfif>

<cfif isdefined("form.fechai") and len(trim(form.fechai)) >
	<cfset vFechai = lsparseDateTime(form.fechai) >
<cfelse>
	<cfset vFechai = createdate(1900, 01, 01) >
</cfif>
<cfif isdefined("form.fechaf")  and len(trim(form.fechaf)) >
	<cfset vFechaf = lsparseDateTime(form.fechaf) >
<cfelse>
	<cfset vFechaf = createdate(6100, 01, 01) >
</cfif>

<cfif isdefined("url.LEstado") and not isdefined("form.LEstado")>
	<cfset form.LEstado = Url.LEstado>
	<cfset form.LEstado = Url.LEstado>
</cfif>

<cfif isdefined("url.fCFid") and not isdefined("form.fCFid")>
	<cfset form.fCFid = Url.fCFid>
	<cfset form.fCFid = Url.fCFid>
</cfif>

<cfif isdefined("url.CFcodigo") and not isdefined("form.CFcodigo")>
	<cfset form.CFcodigo = Url.CFcodigo>
	<cfset form.CFcodigo = Url.CFcodigo>
</cfif>

<cfif isdefined("url.CFdescripcion") and not isdefined("form.CFdescripcion")>
	<cfset form.CFdescripcion = Url.CFdescripcion>
	<cfset form.CFdescripcion = Url.CFdescripcion>
</cfif>

<cfif isdefined("url.fCMTScodigo") and not isdefined("form.CFdescripcion")>
	<cfset form.CFdescripcion = Url.CFdescripcion>
	<cfset form.CFdescripcion = Url.CFdescripcion>
</cfif>

<cfif isdefined("url.fCMTSdescripcion") and not isdefined("form.CFdescripcion")>
	<cfset form.CFdescripcion = Url.CFdescripcion>
	<cfset form.CFdescripcion = Url.CFdescripcion>
</cfif>

<!--- Rango de solicitudes --->
<cfif isdefined("form.ESNnumero1") and len(trim(form.ESNnumero1)) and isdefined("form.ESNnumero2") and len(trim(form.ESNnumero2)) >
	<cfif compare(form.ESNnumero1, form.ESNnumero2) eq 1 >
		<cfset tmp = form.ESNnumero1 >
		<cfset form.ESNnumero1 = form.ESNnumero2 >
		<cfset form.ESNnumero2 = tmp >
	</cfif>
</cfif>

<!--- Rango de fechas --->
<cfif isdefined("vFechai") and isdefined("vFechaf") >
	<cfif DateCompare(vFechai, vFechaf) eq 1 >
		<cfset tmp = vFechai >
		<cfset vFechai = vFfechaf >
		<cfset vFechaf = tmp >
	</cfif>
</cfif>

<cfquery name="data0" datasource="#session.DSN#">
	select count(1) as CantidadRegistros
	from DSolicitudCompraCM a
		inner join Unidades k
			on a.Ucodigo = k.Ucodigo
			and a.Ecodigo = k.Ecodigo
		  
		inner join ESolicitudCompraCM b
			on a.ESidsolicitud=b.ESidsolicitud
		 
		left outer join SNegocios c
			on b.SNcodigo=c.SNcodigo
			and b.Ecodigo=c.Ecodigo
	
		inner join CFuncional cf
    		on b.CFid=cf.CFid
    
	    left outer join Monedas m
    	    on b.Mcodigo = m.Mcodigo        

	    inner join CMTiposSolicitud cmt
    	    on b.CMTScodigo = cmt.CMTScodigo
        	and b.Ecodigo = cmt.Ecodigo 
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
     
    <cfif isdefined("form.LEstado") and len(trim(form.LEstado))>
    	<cfif form.LEstado eq -1>
				and b.ESestado in (0,-10,10,20,40)
			<cfelse>
				and b.ESestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.LEstado#">
			</cfif>
   	</cfif>
    	and ESfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechai#"> 
    		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaf#">	
    <cfif isdefined("form.ESnumero1") and len(trim(form.ESnumero1)) and isdefined("form.ESnumero2") and len(trim(form.ESnumero2))>
		and b.ESnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero1#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero2#"> 
	<cfelseif isdefined("form.ESnumero1") and len(trim(form.ESnumero1))>
		and b.ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero1#">
    <cfelseif isdefined("form.ESnumero2") and len(trim(form.ESnumero2))>
		and b.ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero2#"> 
	</cfif>  
    <cfif isdefined("form.fCFid") and len(trim(form.fCFid))>  
		and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fCFid#">
    </cfif>
	<cfif form.MCodigoORI neq -1>
    	and m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MCodigoORI#"> 
	</cfif>
    <cfif isdefined('form.FCMTScodigo') and len (trim(form.FCMTScodigo))>
        and b.CMTScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FCMTScodigo#">   
    </cfif>    
	<!--- Filtro por Solicitante --->
	<cfif isdefined('form.CMSid') and len (trim(form.CMSid))>
        and b.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMSid#">   
    </cfif> 
</cfquery>

<cfif data0.CantidadRegistros GT 3000>
	<cf_errorCode	code = "50275"
					msg  = "Se han procesado mas de 3000 registros. La consulta regresa @errorDat_1@. Por favor sea mas especifico en los filtros seleccionados"
					errorDat_1="#data0.CantidadRegistros#"
	>
	<cfreturn>
</cfif>

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="data" datasource="#session.DSN#">
	select 	emp.Edescripcion, cf.Ocodigo,
			c.SNcodigo, c.SNnumero, c.SNnombre, 
			b.ESnumero, 
			m.Miso4217,
            b.Mcodigo,
			m.Mnombre,
			a.DSconsecutivo,             
			a.DScant, 
			b.ESfecha,
            b.ESfechaAplica,
			k.Ucodigo,
            b.CMTScodigo,
            cmt.CMTSdescripcion,
			case a.DStipo 	when 'A' then rtrim(ltrim(Acodigo)) 
            						when 'S' then rtrim(ltrim(e.Ccodigo)) 
                                    when 'F' then DSdescripcion 
				end as CodigoItem,
				
            case a.DStipo 	when 'A' then <cf_dbfunction name='sPart' args='d.Adescripcion |1|20' delimiters='|'> #_Cat# 
																case when <cf_dbfunction name="length" args="d.Adescripcion"> > 20 then '...' else '' end 
            						when 'S' then <cf_dbfunction name='sPart' args='e.Cdescripcion |1|20' delimiters='|'> #_Cat# 
																case when <cf_dbfunction name="length" args="e.Cdescripcion"> > 20 then '...' else '' end 
                                    when 'F' then <cf_dbfunction name='sPart' args='DSdescripcion |1|20' delimiters='|'> #_Cat# 
																case when <cf_dbfunction name="length" args="DSdescripcion"> > 20 then '...' else '' end 
				end as DSdescripcion,                        
				
				case a.DStipo 	when 'A' then d.Adescripcion 
            						when 'S' then e.Cdescripcion 
                                    when 'F' then  DSdescripcion end as Descripcion,                        
            
			case b.ESestado when -10 then 'Rechazada por Presupuesto' 
									when 0 then 'Pendiente' 
									when 10 then 'En tr&aacute;mite de aprobaci&oacute;n' 
									when 20 then 'Aplicada' 
									when 25 then 'Orden de Compra Directa' 
									when 40 then 'Parcialmente Surtida' 
									when 50 then 'Surtida' 
									when 60 then 'Cancelada' end as ESestado,
			cf.CFcodigo,
			(select min(u.Usulogin)
			from ESolicitudCompraCM sc
			inner join CMSolicitantes b
			on b.CMSid=sc.CMSid
			
			inner join UsuarioReferencia ur
			on ur.llave = <cf_dbfunction name="to_char" args="sc.CMSid">
			and ur.STabla = 'CMSolicitantes'
			and ur.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
			
			inner join Usuario u
			on u.Usucodigo=ur.Usucodigo
			
			where sc.ESidsolicitud = a.ESidsolicitud) as solicitante,

			#LvarOBJ_PrecioU.enSQL_AS("a.DSmontoest")#,

			coalesce((
            	select imp.Iporcentaje
				  from Impuestos imp
				 where imp.Ecodigo=a.Ecodigo 
				   and imp.Icodigo=a.Icodigo
			), 0) as impuesto
			
	from DSolicitudCompraCM a	
    	 
	   inner join ESolicitudCompraCM b
	       on a.ESidsolicitud=b.ESidsolicitud
    
	   inner join Unidades k
	       on a.Ucodigo = k.Ucodigo
	       and a.Ecodigo = k.Ecodigo	
    
	   left outer join SNegocios c
			on b.SNcodigo=c.SNcodigo
			and b.Ecodigo=c.Ecodigo
	
		left outer join Articulos d
			on a.Ecodigo=b.Ecodigo
			and a.Aid=d.Aid
	
		left outer join Conceptos e
			on a.Ecodigo=e.Ecodigo
			and a.Cid=e.Cid

		inner join CFuncional cf
			on cf.CFid = a.CFid
	
		inner join CMTiposSolicitud cmt
		    on b.CMTScodigo = cmt.CMTScodigo
            and b.Ecodigo = cmt.Ecodigo  
        
		inner join Monedas m
			on m.Ecodigo = b.Ecodigo
            and m.Mcodigo = b.Mcodigo
	
		inner join Empresas emp
			on emp.Ecodigo = a.Ecodigo 
        
        inner join Oficinas ofi
            on ofi.Ecodigo = cf.Ecodigo
            and ofi.Ocodigo = cf.Ocodigo

	where 1=1
    	<cfif #form.ubicacion# EQ 1>
    		and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfelseif ListFirst(form.ubicacion) EQ 'of'>
    		and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
		<cfif len(trim(#form.Ocodigo#))>
        	and ofi.Ocodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
		</cfif>
		<cfelseif ListFirst(form.ubicacion) EQ 'ge'>
			and exists(Select 1 from AnexoGEmpresaDet where Ecodigo = emp.Ecodigo <cfif len(trim(#form.GEid#))> and GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEid#"> </cfif>)	
		</cfif>	

    	<cfif isdefined("form.LEstado") and len(trim(form.LEstado))>		
			<cfif form.LEstado eq -1>
				and b.ESestado in (0,-10,10,20,40)
			<cfelse>
				and b.ESestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.LEstado#">
			</cfif>
	    </cfif>
    
    		and b.ESfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechai#"> 
    		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaf#">
        
		<cfif isdefined("form.ESnumero1") and len(trim(form.ESnumero1)) and isdefined("form.ESnumero2") and len(trim(form.ESnumero2))>
			and b.ESnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero1#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero2#">	
		<cfelseif isdefined("form.ESnumero1") and len(trim(form.ESnumero1))>
			and b.ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero1#"> 
		<cfelseif isdefined("form.ESnumero2") and len(trim(form.ESnumero2))>
			and b.ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero2#"> 
		 </cfif>
    	<cfif isdefined("form.fCFid") and len(trim(form.fCFid))>  
			and b.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fCFid#">
	    </cfif>
		<cfif form.MCodigoORI neq -1>
    		and b.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MCodigoORI#"> 
		</cfif>
    	<cfif isdefined('form.FCMTScodigo') and len (trim(form.FCMTScodigo))>
        	and b.CMTScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FCMTScodigo#">   
	    </cfif>
		<!--- Filtro por Solicitante --->
		<cfif isdefined('form.CMSid') and len (trim(form.CMSid))>
			and b.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMSid#">   
		</cfif> 
	order by m.Miso4217, SNnumero, solicitante,  b.ESnumero, b.CMTScodigo, a.DSconsecutivo, b.ESfecha
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
	<tr> 
		<td colspan="6" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cfoutput>#session.Enombre#</cfoutput></strong></td>
	</tr>
	<tr> 
		<td colspan="6" class="letra" align="center"><b>Consulta de Montos por Solicitud de Compra</b></td>
	</tr>
	<cfoutput> 
	<tr>
		<td colspan="6" align="center" class="letra"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
	</tr>
	</cfoutput> 			
</table>
<br>
<table width="100%" cellpadding="1" border="0" cellspacing="0" align="center">
<cfset corte = ''>
<cfset total = 0>
<cfset totalmoneda = 0>
<cfoutput query="data" group="Miso4217">
	<tr><td colspan="15" >&nbsp;</td></tr>
    <tr>
    	<td class="letra2" width="1%" nowrap colspan="1"><strong>Moneda:&nbsp;</strong></td>
    	<td class="letra2" colspan="14"><strong>#Miso4217#</strong></td>
    </tr>
    <cfset totalmoneda = 0 >
	<cfoutput group="SNcodigo">
		<tr>
        	<td class="bottomline" width="1%" nowrap colspan="1"><strong>Proveedor:&nbsp;</strong></td><td colspan="<cfif ListFirst(form.ubicacion) EQ 'ge'>14<cfelse>13</cfif>" class="bottomline"><strong>#SNnumero# - #SNnombre#</strong></td>
        </tr>
		<tr bgcolor="##f5f5f5" >
	        <td align="center"  width="7%" class="letra2">Estatus</td>
			<td class="letra2" width="6%" >Fecha</td>
			<td class="letra2" width="6%">Fecha Aprob.</td>
			<td class="letra2" width="7%">Sol.</td>
			<td class="letra2" width="4%">Lin.</td>
			<td  align="right" class="letra2" width="7%">Cod.</td>
			<td class="letra2" width="20%"><span class="item">Item</span></td>
			<td class="letra2" width="12%">Ctro.</td>
            <td width="4%" class="letra2">Cant.</td>
			<td width="3%"  class="letra2">Unid.</td>
			<cfif isdefined("form.mostrarMontos") and form.mostrarMontos eq 1>
				<td align="right" class="letra2">Monto</td>
			</cfif>
            <cfif isdefined("form.mostrarMontos") and form.mostrarMontos eq 1>
				<td align="right" class="letra2">Imp.</td>
            </cfif>
			<cfif isdefined("form.mostrarMontos") and form.mostrarMontos eq 1>
				<td align="right" class="letra2">SubTotal</td>			
			</cfif>
			<cfif ListFirst(form.ubicacion) EQ 'ge'>
			  <td align="center" class="letra2">Empresa</td>
			</cfif>
		</tr>
		<tr bgcolor="##f5f5f5" >
	        <td align="center" class="letra2">&nbsp;</td>
			<td class="letra2" >&nbsp;</td>
			<td class="letra2">&nbsp;</td>
			<td class="letra2">&nbsp;</td>			
			<td class="letra2">&nbsp;</td>
			<td align="right" class="letra2">&nbsp;</td>
			<td class="letra2">&nbsp;</td>
			<td class="letra2">Funcional</td>
			<td class="letra2">&nbsp;</td>
            <td class="letra2">Medida</td>
			<cfif isdefined("form.mostrarMontos") and form.mostrarMontos eq 1>		
				<td  class="letra2">&nbsp;</td>
			</cfif>
            <cfif isdefined("form.mostrarMontos") and form.mostrarMontos eq 1>	
				<td align="right" class="letra2">&nbsp;</td>
            </cfif>
			<cfif isdefined("form.mostrarMontos") and form.mostrarMontos eq 1>
				<td align="right" class="letra2">&nbsp;</td>
			</cfif>
            <cfif ListFirst(form.ubicacion) EQ 'ge'>
				<td align="center" class="letra2">&nbsp;</td>
			</cfif>	
    </tr>
		
		<cfoutput group="solicitante">
				<cfif data.currentrow neq 1> 
					<tr><td>&nbsp;</td></tr>
				</cfif>
                <cfoutput group="CMTScodigo">
					<tr>
                    	<td class="csssolicitante" width="1%" nowrap colspan="14">
                        	<strong>Solicitante:&nbsp;</strong>#data.Solicitante#
                    		<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Tipo de Solicitud:&nbsp;</strong>#data.CMTScodigo# - #data.CMTSdescripcion#
                        </td>
                    </tr>
					<cfset total = 0 >
					<cfoutput>
					<cfset total = total + 0 >
					<!--- <tr class="<cfif data.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" style="padding-bottom:5px;">
						<td class="item" colspan="1" >Item:</td>
						<td class="letra" colspan="13"  title="#data.DSdescripcion#" ><cfif len(data.DSdescripcion) gt 40>#mid(data.DSdescripcion,1,40)#...<cfelse>#data.DSdescripcion#</cfif></td>
					</tr> --->
					<tr class="<cfif data.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
	                    <td class="letra" align="center">#data.ESestado#</td>
						<td class="letra" style="padding-left:10px; ">#LSDateFormat(data.ESfecha,'dd/mm/yyyy')#</td>
						<td class="letra" style="padding-left:10px; ">#LSDateFormat(data.ESfechaAplica,'dd/mm/yyyy')#</td>
						<td class="letra" style="padding-left:10px; ">#data.ESnumero#</td>
						<td class="letra" style="padding-left:10px; ">#data.DSconsecutivo#</td>
						<td align="right" class="letra" style="padding-left:10px; " >#data.CodigoItem#</td>
						<td class="letra" style="padding-left:10px;" <cfif #data.Descripcion# neq "">title="#data.Descripcion#"</cfif>>
							<cfif not isdefined("form.toExcel")>
								 #data.DSdescripcion# 
							 <cfelse>
								 #data.Descripcion#
							</cfif>     
						</td>		
						<td class="letra" style="padding-left:10px; " >#data.CFcodigo#</td>                      
                        <td class="letra" style="padding-left:10px; ">#LSCurrencyFormat(data.DScant,'none')#</td>
						<td class="letra" >#data.Ucodigo#</td>
						<cfif isdefined("form.mostrarMontos") and form.mostrarMontos eq 1>
							<td class="letra" style="padding-left:10px; "align="right">#LvarOBJ_PrecioU.enCF(data.DSmontoest)#</td>
						</cfif>
                        <cfif isdefined("form.mostrarMontos") and form.mostrarMontos eq 1>
                            <td class="letra" style="padding-left:10px; "align="right">
                                <cfset vImpuesto =  ( data.DScant*data.DSmontoest )*(data.impuesto/100)>
                                #LSCurrencyFormat(vImpuesto,'none')#
                            </td>	
                        </cfif>
						<cfif isdefined("form.mostrarMontos") and form.mostrarMontos eq 1>
							<td class="letra" style="padding-left:10px; "align="right">
								<cfset vSubtotal =  ( data.DScant*data.DSmontoest ) +  (( data.DScant*data.DSmontoest )*(data.impuesto/100))>
								<cfset total = total + vsubtotal >
								#LSCurrencyFormat(vSubtotal,'none')#
							</td>				
						</cfif>
						<cfif ListFirst(form.ubicacion) EQ 'ge'>
						  <td class="letra" style="padding-left:10px; " align="center" >#data.Edescripcion#</td>
						</cfif>	
					</tr>
                    
					</cfoutput> <!--- TODOS --->
					<cfif isdefined("form.mostrarMontos") and form.mostrarMontos eq 1>
						<tr>
							<td colspan="12" class="letra4" align="right">Total:&nbsp;</td>
							<td align="right" class="letra4">#LSCurrencyFormat(total,'none')#</td>
						</tr>
					</cfif>
                    <tr>
                    	<td colspan="19" >&nbsp;</td>
                    </tr>
					<cfset totalmoneda = totalmoneda + total >
                </cfoutput> <!--- TIPO DE SOLICITUD --->
	        </cfoutput> <!--- SOLICITANTE --->
	</cfoutput> <!--- SOCIO --->
    		<cfquery name="data2" datasource="#session.DSN#"><!--- CALCULAR TOTALES POR ESTADO --->
                select Sum((a.DScant*a.DSmontoest ) + (( a.DScant* a.DSmontoest )*(coalesce((select imp.Iporcentaje
                        from Impuestos imp
                        where imp.Ecodigo=a.Ecodigo 
                               and imp.Icodigo=a.Icodigo),0)/100))) as suma,
                        case b.ESestado when -10 then 'Rechazada por Presupuesto' 
                                        when 0   then 'Pendiente' 
                                        when 10  then 'En tr&aacute;mite de aprobaci&oacute;n' 
                                        when 20  then 'Aplicada'
                                        when 25  then 'Orden de Compra Directa' 
                                        when 40  then 'Parcialmente Surtida' 
                                        when 50  then 'Surtida' 
                                        when 60  then 'Cancelada' 
                        end as Estado                        
                from DSolicitudCompraCM a
                 
                	inner join Unidades k
                    	on a.Ucodigo = k.Ucodigo
                    	and a.Ecodigo = k.Ecodigo
                      
                	inner join ESolicitudCompraCM b
                    	on a.ESidsolicitud=b.ESidsolicitud
                     
                	left outer join SNegocios c
                    	on b.SNcodigo=c.SNcodigo
                    	and b.Ecodigo=c.Ecodigo
                
                	inner join CFuncional cf
                    	on b.CFid=cf.CFid
                
                	left outer join Monedas m
                    	on b.Mcodigo = m.Mcodigo        
            
                	inner join CMTiposSolicitud cmt
                    	on b.CMTScodigo = cmt.CMTScodigo
                    	and b.Ecodigo = cmt.Ecodigo 
                where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
					<cfif isdefined("form.LEstado") and len(trim(form.LEstado))>
						<cfif form.LEstado eq -1>
							and b.ESestado in (0,-10,10,20,40)
						<cfelse>
							and b.ESestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.LEstado#">
						</cfif>
                    </cfif>
                    and ESfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechai#"> 
                		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaf#">	
                     
                    <cfif isdefined("form.ESnumero1") and len(trim(form.ESnumero1)) and isdefined("form.ESnumero2") and len(trim(form.ESnumero2))>
                        and b.ESnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero1#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero2#"> 
                    <cfelseif isdefined("form.ESnumero1") and len(trim(form.ESnumero1))>
                        and b.ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero1#">
                    <cfelseif isdefined("form.ESnumero2") and len(trim(form.ESnumero2))>
                        and b.ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero2#"> 
                    </cfif>  
                    <cfif isdefined("form.fCFid") and len(trim(form.fCFid))>  
                        and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fCFid#">
                    </cfif>
                    <cfif form.MCodigoORI neq -1>
                        and m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MCodigoORI#"> 
                    </cfif>
                    <cfif isdefined('form.FCMTScodigo') and len (trim(form.FCMTScodigo))>
                        and b.CMTScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FCMTScodigo#">   
                    </cfif>   
                    and b.Mcodigo = #data.Mcodigo#
                group by b.ESestado
            </cfquery>
			<cfif isdefined("form.mostrarMontos") and form.mostrarMontos eq 1>
					<tr>
						<td colspan="12" class="letra3" align="right">Total #Miso4217#:&nbsp;</td>
						<td align="right" class="letra3">#LSCurrencyFormat(totalmoneda,'none')#</td>
					</tr>               
				<cfif data2.recordcount gt 0>
					<tr>
						<td colspan="12" class="letra4" align="right">Total:&nbsp;</td>					
					</tr>
				<cfloop query="data2">     
				   <tr>
						<td colspan="12"  class="letra4" align="right">&nbsp;</td>
						<td align="right"  class="letra4">#data2.Estado#:&nbsp;#LSCurrencyFormat(data2.suma,'none')#</td>
					</tr> 
				</cfloop>
				</cfif>
            </cfif>
</cfoutput> <!--- MONEDA --->
	<!--- ultimo total --->
	<!---
	<tr>
		<td colspan="10" class="letra2" align="right">Total:&nbsp;</td>
		<td align="right" class="letra2"><cfoutput>#LSCurrencyFormat(total,'none')#</cfoutput></td>
	</tr>
	--->
	<cfif data.RecordCount gt 0 >
		<tr><td colspan="19" align="center">&nbsp;</td></tr>
		<tr><td colspan="19" align="center" class="letra">------------------ Fin del Reporte ------------------</td></tr>
	<cfelse>
		<tr><td colspan="19" align="center">&nbsp;</td></tr>
		<tr><td colspan="19" align="center" class="letra">--- No se encontraron datos ----</td></tr>
	</cfif>
</table>
<br>