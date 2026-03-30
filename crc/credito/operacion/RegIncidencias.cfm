<style type="text/css">
	.list_incidencias .PlistaTable {width: 100%;}
</style>

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Cliente" default = "Cliente" returnvariable="LB_Cliente" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Observacion" default = "Observaciones" returnvariable="LB_Observacion" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Fecha" default = "Fecha" returnvariable="LB_Fecha" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_GastoCobranza" default = "Gener&oacute; Gasto de Cobranza" returnvariable="LB_GastoCobranza" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Monto" default = "Monto" returnvariable="LB_Monto" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Reportado" default = "Reportado por" returnvariable="LB_Reportado" xmlfile = "tab_Transaccion.xml">


<cfparam name="form.id">

<cfif !isdefined('form.codigocorte')>
	<cfset form.codigocorte="#q_currentCorte#">
</cfif>

<cfset filterUsr = "">
<cfset tipoEmpleado = "">
<!--- <cfif parentEntrancePoint eq 'Cuentas.cfm'> --->
	<cfquery name="q_usuario" datasource="#session.DSN#">
		select A.llave,B.isAbogado,B.isCobrador from UsuarioReferencia A 
			inner join DatosEmpleado B 
				on A.llave = B.DEid 
		where A.Usucodigo = #session.usucodigo# and STabla = 'DatosEmpleado';
	</cfquery>
	
	<cfset filterUsr = "(c.DatosEmpleadoDEid = #q_usuario.llave# or c.DatosEmpleadoDEid2 = #q_usuario.llave#) and">
	<cfif q_usuario.isAbogado eq 1>
		<cfset tipoEmpleado = "AB">
	<cfelseif q_usuario.isCobrador eq 1>
		<cfset tipoEmpleado = "GE">
	</cfif>
<!--- </cfif> --->


<cfset corteInciFiltro = q_currentCorte>
<cfif isDefined('form.codigoCorte')>
	<cfset corteInciFiltro = form.codigoCorte>
</cfif>

<cfoutput>
	<div style="height: 100%; width:100%; font-size: 0;">
		<div style="width: 100%; display: inline-block; *display: inline; zoom: 1; vertical-align: top; font-size: 12px;">
			<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td class="list_incidencias">
						<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
							tabla="CRCIncidenciasCuenta A
									left join DatosEmpleado B
									on B.DEid = A.DatosEmpleadoDEid"
							columnas="
								A.id as idInci,
								A.Corte,
								CONCAT(SUBSTRING(A.Observaciones,0,30),' ...') as ObservacionesInci,
								case A.TipoEmpleado
									when 'GE' then 'Gestor'
									when 'AB' then 'Abogado'
									else 'N/D'
								end as TipoEmpleadoInci,
								A.Monto as MontoInci,
								case A.TransaccionPendiente
									when 0 then 'PENDIENTE'
									when 1 then 'APLICADA'
									when 2 then 'N/A'
									when 3 then 'RECHAZADA'
								end as TransaccionPendienteDescripInci,
								A.TransaccionPendiente as TransaccionPendienteInci,
								A.DatosEmpleadoDEid as DatosEmpleadoDEidInci,
								CONCAT(SUBSTRING(CONCAT(B.DEnombre,' ',B.DEapellido1,' ',B.DEapellido2),0,20),' ...') as DENombre"
							desplegar="Corte,ObservacionesInci,TipoEmpleadoInci,MontoInci,TransaccionPendienteDescripInci,DENombre"
							etiquetas="Corte,Observaciones,TipoEmpleado,Monto,Estado,Reportada Por"
							formatos="S,S,S,S,S,S"
							filtro="A.Ecodigo=#session.Ecodigo# and A.CRCCuentasid = #form.id# and A.Corte = '#corteInciFiltro#'"
							align="left,left,left,left,left,left"
							checkboxes="N"
							keys="idInci">
						</cfinvoke>
					</td>
				</tr>
			</table>
		</div>
	</div>
</cfoutput>

<script>
    //document.form1.btnEliminar .value='Rechazar'
	function countCharacter(v){
		document.getElementsByName('txtAreaCounter')[0].innerHTML=v.length+"/255";
		document.getElementsByName('Observaciones')[0].innerHTML=document.getElementsByName('Observaciones')[0].innerHTML.replace('\n','');
		document.getElementsByName('Observaciones')[0].value=document.getElementsByName('Observaciones')[0].value.replace('\n','');
	}
	function justNumbers(e) {
        var keynum = window.event ? window.event.keyCode : e.which;
        if ((keynum == 8) || (keynum == 46))
        return true;
         
        return /\d/.test(String.fromCharCode(keynum));
        }
	
	function aprobarInci(t){
		
		var msg = 'APLICAR';
		if(t == 'r'){msg = 'RECHAZAR';}

		if(confirm('Esta seguro de ' + msg + ' la incidencia?')){
			if(document.getElementsByName('TPendiente')[0].value == '1'){
				alert('La transaccion ya fue aprobada');
			}else if(document.getElementsByName('TPendiente')[0].value == '2'){
				alert('La transaccion no requiere aprobacion');
			}else{
				document.getElementsByName('procesarInciComo')[0].value=t;
				setWhatToDo('ProcessINCI');
			}
		}
		return false;
	}
</script>