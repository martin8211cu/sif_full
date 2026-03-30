<style type="text/css">
	.tablaborde {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #CCCCCC;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #CCCCCC;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #CCCCCC;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #CCCCCC;
		
	}

	.letra {
		font-size:11px;
	}
</style>

<cfif isdefined("form.ETconsecutivo_move1") and len(trim(form.ETconsecutivo_move1)) and not(isdefined("form.ETidtracking") and len(trim(form.ETidtracking))) and not(isdefined("form.ETnumtracking") and len(trim(form.ETnumtracking)))>
	<cfquery name="rsDatos" datasource="sifpublica">
		select ETidtracking, ETnumtracking
		from ETracking
		where ETconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETconsecutivo_move1#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset form.ETidtracking_move1 = rsDatos.ETidtracking>
	<cfset form.ETnumtracking_move1 = rsDatos.ETnumtracking>
</cfif>

<cfif isdefined("url.ETidtracking_move1") and not isdefined("form.ETidtracking_move1")>
	<cfset form.ETidtracking_move1 = Url.ETidtracking_move1>
</cfif>

<cfif isdefined("url.pantalla")>
	<cfset pantalla = Url.pantalla>
</cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
	<tr> 
	<td colspan="6" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cfoutput>#session.Enombre#</cfoutput></strong></td>
	</tr>
	<tr> 
	<td colspan="6" class="letra" align="center"><b>Consulta de Tracking de Embarque</b></td>
	</tr>
	<cfoutput> 
		<tr><td colspan="6" align="center" class="letra"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td></tr>	 			
		<tr><td>&nbsp;</td></tr>	
		<cfif not isdefined("url.imprimir")>
			<tr><td colspan="6" class="letra">&nbsp;&nbsp;&nbsp;<strong><a href="seguimientoTrackingItems-form.cfm?ETidtracking_move1=#form.ETidtracking_move1#&pantalla=#pantalla#">Ver detalles</a></strong></tr>
		</cfif>
	</cfoutput>
</table>
<br>

<!--- Encabezado del Tracking de embarque --->
<!----b.ETdescripcion----->

<!----
	select 	a.ETidtracking, 
			a.ETnumtracking, 
			a.ETcodigo, 
			a.ETnumreferencia, 
			a.CRid, 
			a.ETfechagenerado, 
			a.ETfechaestimada, 
			a.ETfechaentrega, 
			a.ETfechasalida,
			a.ETestado			
	from ETracking a
			inner join EstadosTracking b
				on a.Ecodigo=b.Ecodigo
				and a.ETcodigo=b.ETcodigo
	
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.ETidtracking=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking_move1#">  	
--->	  


<cfquery datasource="sifpublica" name="dataEncabezado">
		select a.ETidtracking, 
	           a.ETconsecutivo, 
		       a.ETnumtracking, 
		       a.CEcodigo, 
		       a.EcodigoASP,
		       a.Ecodigo, 
			   a.ETcodigo, 
			   a.cncache, 
			   a.EOidorden, 
		       a.ETnumreferencia,
			   a.CRid, 
			   a.ETfechagenerado, 
			   a.ETfechaestimada, 
			   a.ETfechaentrega, 
			   a.ETfechasalida, 
		       a.ETnumembarque, 
		       a.ETrecibidopor, 
			   case a.ETmediotransporte 
			   		when 0 then 'Tierra' 
					when 1 then 'Aéreo'
					when 2 then 'Barco'
					when 3 then 'Primera Clase'
					when 4 then 'Prioridad'
					when 5 then 'Otro'
					else ''
			   end as MedioTransporte, 
			   '' as CRdescripcion,
			   a.BMUsucodigo, a.ETestado, a.ETcampousuario, a.ETcampopwd, b.ETdescripcion
		from ETracking a
		        inner join EstadosTracking b
				   on a.Ecodigo = b.Ecodigo
				   and a.ETcodigo = b.ETcodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	          and a.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking_move1#"> 			
</cfquery>

<cfquery name="rsOrdenes" datasource="#session.dsn#">
        select distinct d.EOnumero
        from ETrackingItems a  
            inner join DOrdenCM d
                on d.DOlinea = a.DOlinea
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            and a.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking_move1#"> 	  	 
            and a.ETIestado = 0 	 
        group by d.EOnumero
     </cfquery>
	<cfset cont = 0>
    <cfset LvarOrdenes = "">
    <cfloop query="rsOrdenes">
		 <cfif LvarOrdenes neq "" and rsOrdenes.recordcount gt 0>
         	<cfif cont LT 4>
            	<cfset LvarOrdenes = LvarOrdenes&"|"&rsOrdenes.EOnumero>
            	<cfset cont = cont+1>
            <cfelse>
            	    <cfset LvarOrdenes = LvarOrdenes&"<br>"&rsOrdenes.EOnumero>
            		<cfset cont = 0>
            </cfif>
        <cfelse>
            <cfset LvarOrdenes = LvarOrdenes&rsOrdenes.EOnumero>    
            <cfset cont = cont+1>
        </cfif> 
    </cfloop>
    
    <cfif rsOrdenes.recordcount gt 1>
    	<cfset LvarObservacion = "M&uacute;ltiples Ordenes de Compra">
    <cfelse>
        <cfquery name="dataOrden" datasource="#session.dsn#">
            select Observaciones
            from EOrdenCM
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#dataEncabezado.Ecodigo#">
            and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataEncabezado.EOidorden#">
        </cfquery>
        <cfset LvarObservacion = dataOrden.Observaciones>
    </cfif>

<cfoutput>
<br>
<table width="98%" class="tablaborde" align="center" border="0" cellpadding="2" cellspacing="0" bgcolor="##F5F5F5">	
	 <tr>
		<td align="right" nowrap class="fileLabel">No. Tracking:</td>
		<td nowrap>#dataEncabezado.ETconsecutivo#</td>
		<td align="right" nowrap class="fileLabel">No. Control:</td>
		<td>#dataEncabezado.ETnumtracking#</td>
		<td align="right" nowrap class="fileLabel">Fecha Salida:</td>
		<td width="5%">
			<cfif Len(Trim(dataEncabezado.ETfechasalida))>
				#LSDateFormat(dataEncabezado.ETfechasalida,'dd/mm/yyyy')#
			<cfelse>
				-
			</cfif>
		</td>
		<td colspan="2" rowspan="3" align="center" valign="middle" nowrap>&nbsp;</td>
	  </tr>
	  <tr>
		<td align="right" nowrap class="fileLabel">No. Orden:</td>
		<td nowrap>#LvarOrdenes#</td>
		<td class="fileLabel" align="right" nowrap>Orden de Compra:</td>
		<td  nowrap>#LvarObservacion#</td>
		<td align="right" nowrap class="fileLabel">Fecha Estimada:</td>
		<td width="5%">
			<cfif Len(Trim(dataEncabezado.ETfechaestimada))>
			#LSDateFormat(dataEncabezado.ETfechaestimada,'dd/mm/yyyy')#
			<cfelse>
			-
			</cfif>
		</td>
	  </tr>
	  <tr>
		<td align="right" nowrap class="fileLabel">Courier:</td>
		<td nowrap>#dataEncabezado.CRdescripcion#</td>
		<td align="right" nowrap class="fileLabel">Tracking Courier:</td>
		<td nowrap>#dataEncabezado.ETnumreferencia#</td>
		<td align="right" nowrap class="fileLabel">Fecha Llegada:</td>
		<td width="5%">
			<cfif Len(Trim(dataEncabezado.ETfechaentrega))>
			#LSDateFormat(dataEncabezado.ETfechaentrega,'dd/mm/yyyy')#
			<cfelse>
			-
			</cfif>
		</td>
	  </tr>
	  <tr>
		<td align="right" nowrap class="fileLabel">No. Embarque: </td>
		<td nowrap>#dataEncabezado.ETnumembarque#</td>
		<td align="right" nowrap class="fileLabel">Medio Transporte: </td>
		<td nowrap>#dataEncabezado.MedioTransporte#</td>
		<td align="right" nowrap class="fileLabel">Recibido por: </td>
		<td width="20%">#dataEncabezado.ETrecibidopor#</td>
	  </tr>	  
</table>
</cfoutput>
<br>

<!---- DTdescripcion,DTfechasalida,DTfechallegada,   ---->
<cfquery name="dataDetalle" datasource="sifpublica">
	select a.DTidtracking, 
		   a.ETidtracking, 
		   a.CEcodigo, 
		   a.EcodigoASP, 
		   a.Ecodigo, 
		   a.cncache, 
		   a.DTactividad, 
		   a.DTubicacion, 
		   a.Observaciones, 
		   a.DTtipo, 
		   a.DTfecha, 
		   a.DTfechaincidencia, 
		   a.DTfechaest, 
		   a.BMUsucodigo, 
		   a.CRid, 
		   a.DTnumreferencia, 
		   a.DTcampousuario, 
		   a.DTcampopwd, 
		   a.ETcodigo, 
		   a.DTrecibidopor
	from DTracking a		
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking_move1#">
	order by a.DTfecha desc
</cfquery>

<cfoutput>
<table align="center" width="98%" cellpadding="2" cellspacing="0">
	<tr class="tituloListas">
		<td nowrap width="9%" style="border-top:1px solid black; border-bottom:1px solid black;border-left:1px solid black; border-right:1px solid black;"><strong>Tipo Actividad</strong></td>
		<td nowrap width="40%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;"><strong>Actividad</strong></td>
		<td nowrap width="9%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;"><strong>Fecha</strong></td>
		<td nowrap width="40%" style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;"><strong>Ubicación</strong></td>
		<!---<td style="border-top:1px solid black; border-bottom:1px solid black;border-right:1px solid black;"><strong>Referencia</strong></td>--->
	</tr>
	
	<cfloop query="dataDetalle">
		<tr>
			<td width="9%" style="border-bottom:1px solid black;border-right:1px solid black; border-left:1px solid black;" >
				<cfif dataDetalle.DTtipo EQ 'E'>
				    Entrada
				<cfelseif dataDetalle.DTtipo EQ 'S'>
				    Salida
				<cfelseif dataDetalle.DTtipo eq 'T'>
				    Entrega
				<cfelseif dataDetalle.DTtipo eq 'C'>
					Consolidacion
				<cfelseif dataDetalle.DTtipo eq 'M'>
					Transaccion
				<cfelse>
				     -   
				</cfif>				
			</td>
			<td width="40%" style="border-bottom:1px solid black;border-right:1px solid black;">#dataDetalle.DTactividad#</td>
			<td width="9%" style="border-bottom:1px solid black;border-right:1px solid black;"><cfif len(trim(dataDetalle.DTfechaincidencia))>#LSDateFormat(dataDetalle.DTfechaincidencia,'dd/mm/yyyy')#<cfelse>-</cfif></td>
			<td width="40%" style="border-bottom:1px solid black;border-right:1px solid black;"><cfif len(trim(dataDetalle.DTubicacion))>#dataDetalle.DTubicacion#<cfelse>-</cfif></td>
			<!---<td><cfif len(trim(dataDetalle.DTnumreferencia))>#LSDateFormat(dataDetalle.DTnumreferencia,'dd/mm/yyyy')#<cfelse>-</cfif></td>--->
		</tr>
	</cfloop>
	
	<cfif dataDetalle.RecordCount gt 0 >
		<tr><td colspan="6" align="center">&nbsp;</td></tr>
		<tr><td colspan="6" align="center">------------------ Fin del Reporte ------------------</td></tr>
	<cfelse>
		<tr><td colspan="6" align="center">&nbsp;</td></tr>
		<tr><td colspan="6" align="center">--- No se encontraron datos ----</td></tr>
	</cfif>

</table>
</cfoutput>
<br>