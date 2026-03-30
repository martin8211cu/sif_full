<!--- Rodolfo Jimenez Jara, el 28/05/2005
	  Se Documentó el enviar Correo al proveedor
      a solicitud de Nelson Baltodano, para Dos Pinos.
--->
<!--- Hay mas jerarquia? --->
<cfquery name="rsJerarquia" datasource="#session.DSN#">
	select CMCid
	from CMAutorizaOrdenes
	where Nivel = #form.Nivel# + 1
	  and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	  and CMAestado = 0
</cfquery>
<cfset msg = "">
<cfif isdefined("form.btnAprobar") >
	<cftransaction>
	<cfquery datasource="#session.DSN#">
		update CMAutorizaOrdenes
		set CMAestado = 2,
			CMAjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.justificacion)#" null="#Len(Trim(form.justificacion)) Is 0#">
		where CMAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMAid#">
 		  and CMAestado <> 1
		  and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	</cfquery>
	
	<!--- Envio de correo al siguiente comprador, segun la jerarquia --->
	<cfif rsJerarquia.recordcount gt 0 and len(trim(rsJerarquia.CMCid))>
		<cfquery name="rsComprador" datasource="#session.dsn#">
            select cm.CMCnombre, coalesce(dec.DEemail, dpc.Pemail1, dpc.Pemail2) as Email1
            from CMCompradores cm
                left outer join DatosEmpleado dec
                    on dec.DEid = cm.DEid
                inner join Usuario uc
                    left outer join DatosPersonales dpc
                        on dpc.datos_personales = uc.datos_personales
                    on uc.Usucodigo = cm.Usucodigo
                where cm.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJerarquia.CMCid#">	
        </cfquery>
		<cfif len(trim(rsComprador.Email1))>		
        	<cfset LvarBody = fnEmailAutorizacion(form.EOidorden)>		
			<cfquery datasource="#session.DSN#">
				insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
				values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.datos_personales.email1#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsComprador.Email1#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="Aprobación de Orden de Compra #dataOrden.EOnumero#.">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#_body#">,
						 1 )
			</cfquery>
		</cfif>
	<cfelse>
		
			<cfquery name="rsValida" datasource="#session.DSN#">
				select 	distinct	a.EOnumero,
						a.EOestado,						
						case 	when d.DSlinea is not null and a.EOestado = -7 then 9
                                when d.DSlinea is not null then 5
								when e.CMTScompradirecta = 1 then 7
								when g.DClinea is not null then 8
						else 9
						end as NuevoEstado
						
				from EOrdenCM a
					left outer join DOrdenCM b
						on a.EOidorden = b.EOidorden
				
						left outer join DSolicitudCompraCM c
							on b.DSlinea = c.DSlinea
							and b.ESidsolicitud = c.ESidsolicitud
							and b.Ecodigo = c.Ecodigo
										
							<!----- ES DE TIPO COMPRA DIRECTA? ------>
							left outer join ESolicitudCompraCM f
								on c.ESidsolicitud = f.ESidsolicitud
								and c.Ecodigo = f.Ecodigo
				
							left outer join CMTiposSolicitud e
								on f.CMTScodigo = e.CMTScodigo
								and f.Ecodigo = e.Ecodigo
				
							<!----  ESTA EN UN PROCESO DE PUBLICACION? ------>
							left outer join CMLineasProceso d
								on c.DSlinea = d.DSlinea
								and c.ESidsolicitud = d.ESidsolicitud
								
								<!----- ESTADO DEL PROCESO DE COMPRA EN "CERRADO" ------>
								left outer join CMProcesoCompra h
									on d.CMPid = h.CMPid
									and h.CMPestado = 50
				
							<!----- LOS ARTICULOS/SERVICIOS ESTAN EN UN CONTRATO? ------>
							left outer join DContratosCM g
								on coalesce(c.Aid,c.Cid) = coalesce(g.Aid,g.Cid)	
								and g.DCtipoitem= c.DStipo
						
				where a.EOidorden =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
			</cfquery>
			<cfquery datasource="#session.DSN#">
				update CMAutorizaOrdenes
				set CMAestadoproceso = 15
				where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
				  and CMAestadoproceso <> 10
			</cfquery>

			<cfquery datasource="#session.DSN#">
				update EOrdenCM
				set EOestado = <cfif rsValida.RecordCount NEQ 0 and len(trim(rsValida.NuevoEstado))>#rsValida.NuevoEstado#<cfelse>0</cfif>
				where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
			</cfquery>
		
<!--- Rodolfo Jimenez Jara, el 28/05/2005
	  Se Documentó el enviar Correo al proveedor
      a solicitud de Nelson Baltodano, para Dos Pinos.--->

		<!--- manda correo al comprador asignado a la orden --->
		<cfquery name="dataComprador" datasource="#session.DSN#">
			select CMCid from EOrdenCM where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		</cfquery>
		<cfif dataComprador.RecordCount gt 0  and len(trim(dataComprador.CMCid))>
			<cfquery name="rsComprador" datasource="#session.dsn#">
                select cm.CMCnombre, coalesce(dec.DEemail, dpc.Pemail1, dpc.Pemail2) as Email1
                from CMCompradores cm
                    left outer join DatosEmpleado dec
                        on dec.DEid = cm.DEid
                    inner join Usuario uc
                        left outer join DatosPersonales dpc
                            on dpc.datos_personales = uc.datos_personales
                        on uc.Usucodigo = cm.Usucodigo
                    where cm.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataComprador.CMCid#">	
            </cfquery>
			<cfif len(trim(rsComprador.Email1))>
				<cfset autorizada = true >
                <cfset LvarBody = fnEmailAutorizacion(form.EOidorden)>		
				<cfquery datasource="#session.DSN#">
					insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
					values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.datos_personales.email1#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsComprador.Email1#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Autorización de Orden Compra #dataOrden.EOnumero#.">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#_body#">,
							 1 )
				</cfquery>
			</cfif>
		</cfif>
	</cfif> 
</cftransaction>
<cfelseif isdefined("form.btnRechazar") >
	<cfquery datasource="#session.DSN#">
			update CMAutorizaOrdenes
			set CMAestado = 1,
				CMAestadoproceso = 5,
				CMAjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.justificacion)#" null="#Len(Trim(form.justificacion)) Is 0#">
			where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
			  and CMAestadoproceso <> 10
			  <!--- probar esta parte --->
			  and CMAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMAid#">
		</cfquery>

		<cfquery datasource="#session.DSN#">
			update EOrdenCM
			set EOestado = -8
			where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		</cfquery>	
		<cfif isdefined("form.notificar") and #form.notificar# eq 1>
		<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
		<cfquery name="rsDatosOC" datasource="#session.dsn#">
		     select 
				   a.EOnumero,
				   a.Observaciones,
				   a.EOtotal,
				   c.Pnombre#_Cat#' '#_Cat#c.Papellido1#_Cat#' '#_Cat#c.Papellido2 as Comprador,
				   c.Pemail1 
			from EOrdenCM a 
				inner join  Usuario b
					 on a.Usucodigo = b.Usucodigo 
			   inner join DatosPersonales c
					 on b.datos_personales = c.datos_personales
			where a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		</cfquery>
		<cfset texto='<table border="0" width="100%">				
   	<tr align="center" bgcolor="##0D8BF2">
	   <td align="center">
	     <strong>Compras - Proceso de Jerarquía de compras</strong></td>
	</tr>
   <tr>
	  <td>
		Sr(a): <cfoutput><strong>#rsDatosOC.Comprador#</strong></cfoutput>.<br><br>
	  </td>
   </tr>
   <tr>
	   <td>
		 &nbsp;&nbsp;&nbsp;Este correo es enviado de manera autom&aacute;tica por el sistema.<br><br>
    	   La orden de compra <cfoutput><strong>#rsDatosOC.EOnumero# - #rsDatosOC.Observaciones#</strong></cfoutput>, por un monto de <cfoutput><strong>#LsNumberFormat(rsDatosOC.EOtotal,'9,9.99')#</strong></cfoutput>, ha sido rechazada por el jefe de compras.<br><br>
		   Justificación: <cfoutput>#Trim(form.justificacion)#<cfoutput>
	   </td>
   </tr>
   <tr>
	   <td>
			<br>Si este correo a llegado por equivocaci&oacute;n le solicitamos eliminarlo.
	   </td>
   </tr>
</table>'>																	
			<cfquery datasource="#session.dsn#">
					insert into SMTPQueue (
						SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
					values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosOC.Pemail1#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="Notificacion Rechazo OC">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#texto#">, 1)
			</cfquery>
			<cfset msg= "Se ha enviado la notificación al comprador">
		</cfif>

<cfelseif isdefined("form.btnReiniciar") >
	<cfinvoke component="sif.Componentes.CM_OrdenCompra" method="ReiniciaAutorizacion">
    	<cfinvokeargument name="EOidorden" value="#form.EOidorden#">
    </cfinvoke>
</cfif>
<html>
<head></head>
<body>
<form name="form1" action="autorizaOrden.cfm" method="post"></form>
<script language="javascript1.1" type="text/javascript">
	<cfif len(trim(msg)) gt 0>
	  <cfoutput>
		alert("#msg#");
	   </cfoutput>	
	</cfif>
	document.form1.submit();
</script>
</body>

<cffunction name="fnEmailAutorizacion" access="private" returntype="string">
    <cfargument name="EOidorden" 	type="numeric">

    <cfquery name="dataOrden" datasource="#session.DSN#">
        select a.EOnumero, a.Observaciones, coalesce(a.EOtotal,0) as EOtotal, a.Mcodigo, a.EOfecha, b.Mnombre, c.CMCnombre
          from EOrdenCM a
            inner join Monedas b
             on a.Mcodigo=b.Mcodigo
            and a.Ecodigo=b.Ecodigo
            inner join CMCompradores c
             on a.CMCid=c.CMCid
        where a.EOidorden	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
    </cfquery>

    <cfoutput>
    <cfsavecontent variable="_body">
        <HTML>
            <head>
                <style type="text/css">
                    .tituloIndicacion {
                        font-size: 10pt;
                        font-variant: small-caps;
                        background-color: ##CCCCCC;
                    }
                    .tituloListas {
                        font-weight: bolder;
                        vertical-align: middle;
                        padding: 2px;
                        background-color: ##F5F5F5;
                    }
                    .listaNon { background-color:##FFFFFF; vertical-align:middle; padding-left:5px;}
                    .listaPar { background-color:##FAFAFA; vertical-align:middle; padding-left:5px;}
                    body,td {
                        font-size: 12px;
                        background-color: ##f8f8f8;
                        font-family: Verdana, Arial, Helvetica, sans-serif;
                    }
                </style>
            </head>

            <body>
                <table width="100%" cellpadding="2" cellspacing="0">
                    <tr><td colspan="2" class="tituloAlterno"><strong>Sistema de Compras. <cfif isdefined("autorizada") and autorizada >La siguiente orden de compra ha sido autorizada.<cfelse>La siguiente Orden de Compra requiere de su aprobaci&oacute;n.</cfif></strong></td></tr>
                    <tr>
                        <td style="padding-left:10px;" width="1%"><strong>Orden:&nbsp;</strong></td>
                        <td>#dataOrden.EOnumero#</td>
                    </tr>
                    <tr>
                        <td style="padding-left:10px;" width="1%"><strong>Observaciones:&nbsp;</strong></td>
                        <td>#dataOrden.Observaciones#</td>
                    </tr>
                    <tr>
                        <td style="padding-left:10px;" width="1%" nowrap><strong>Fecha de la Orden:&nbsp;</strong></td>
                        <td>#LSDateFormat(dataOrden.EOfecha,'dd/mm/yyyy')#</td>
                    </tr>
                    <tr>
                        <td style="padding-left:10px;" width="1%"><strong>Comprador:&nbsp;</strong></td>
                        <td>#dataOrden.CMCnombre#</td>
                    </tr>
                    <tr>
                        <td style="padding-left:10px;" width="1%"><strong>Moneda:&nbsp;</strong></td>
                        <td>#dataOrden.Mnombre#</td>
                    </tr>
                    <tr>
                        <td style="padding-left:10px;" width="1%"><strong>Monto:&nbsp;</strong></td>
                        <td>#LSNumberFormat(dataOrden.EOtotal, ',9.00')#</td>
                    </tr>
                    <tr><td colspan="2"><hr size="1" color="##CCCCCC"></td></tr>
                </table>
            </body>
        </HTML>			
    </cfsavecontent>
    </cfoutput>
    <cfreturn _body>
</cffunction>
