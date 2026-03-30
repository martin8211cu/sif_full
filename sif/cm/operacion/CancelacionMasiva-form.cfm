<cf_navegacion name="FILTRO_CMCMDTIPO"		default="">
<cf_navegacion name="FILTRO_CMCMDNUMERO"	default="">
<cf_navegacion name="FILTRO_DESCRIPCION"	default="">
<cf_navegacion name="FILTRO_CMCMDRESULTADO"	default="">
<cf_navegacion name="FILTRO_NAPCANCEL"		default="">
<cf_navegacion name="FILTRO_SNNOMBRE"		default="">
<cf_navegacion name="chkOK"					default="0">
<cf_navegacion name="chkCANCEL"				default="0">

<cfquery name="rsForm" datasource="#session.DSN#">
	select CMCMid,CMCMdescripcion, CMCMfecha, CMCMejecutado
	  from CMcancelacionMasiva
	 where Ecodigo	= #session.Ecodigo#
	   and CMCMid	= #form.CMCMid#
</cfquery>
<cfquery name="rsDet" datasource="#session.DSN#">
	select count(1) as cantidad
	  from CMcancelacionMasivaDet d
	 where d.Ecodigo	= #session.Ecodigo#
	   and d.CMCMid		= #form.CMCMid#
</cfquery>
<cfquery name="rsFormDet" datasource="#session.DSN#">
	select CMCMid, CMCMDtipo, CMCMDnumero, CMCMDresultado, 
			case when CMCMDtipo='SC' and d.DSlinea<>0 then dsc.DSconsecutivo end as DSlinea, 
			case when CMCMDtipo='SC' and d.DSlinea<>0 then d.DScantCancelar end as DScantCancelar, 
			case when CMCMDtipo = 'SC' then 'SOLICITUDES DE COMPRAS' else 'ORDENES DE COMPRAS' end as TTipo,
			case when CMCMDtipo='OC' then oc.NAPcancel else (select max(NAPasociado) from CMSolicCanceladas where DSlinea = d.DSlinea) end as NAPcancel, 
			SNnombre, 
			coalesce(sc.ESidsolicitud, oc.EOidorden, -1) as id, coalesce(ESestado,-1) as ESestado,
			<cf_dbfunction name="spart" args="coalesce(ESobservacion, Observaciones);1;20" delimiters=";"> as descripcion, 
			coalesce(ESfecha, EOfecha) as fecha,
			Miso4217,
			case 
				when CMCMDtipo = 'OC' then EOtotal 
				when d.DSlinea = 0 then EStotalest
				else DStotallinest
			end as total
	  from CMcancelacionMasivaDet d
	  	left join ESolicitudCompraCM sc 
			on sc.Ecodigo = d.Ecodigo and sc.ESnumero = d.CMCMDnumero and d.CMCMDtipo = 'SC'
		left join DSolicitudCompraCM dsc 
			on dsc.DSlinea = d.DSlinea
	  	left join EOrdenCM oc 
			on oc.Ecodigo = d.Ecodigo and oc.EOnumero = d.CMCMDnumero and d.CMCMDtipo = 'OC'
		left join SNegocios sn
			 on sn.Ecodigo  = d.Ecodigo
			and sn.SNcodigo = coalesce(sc.SNcodigo, oc.SNcodigo)
		left join Monedas m
			 on m.Ecodigo  = d.Ecodigo
			and m.Mcodigo = coalesce(sc.Mcodigo, oc.Mcodigo)
	 where d.Ecodigo	= #session.Ecodigo#
	   and d.CMCMid		= #form.CMCMid#
	<cfif form.FILTRO_CMCMDTIPO NEQ "">
	   and CMCMDtipo = '#form.FILTRO_CMCMDTIPO#'
	</cfif>
	<cfif form.FILTRO_CMCMDNUMERO NEQ "" and isnumeric(form.FILTRO_CMCMDNUMERO)>
	   and CMCMDnumero = #form.FILTRO_CMCMDNUMERO#
	</cfif>
	<cfif form.FILTRO_NAPCANCEL NEQ "" and isnumeric(form.FILTRO_NAPCANCEL)>
	   and case when CMCMDtipo='SC' and d.DSlinea<>0 then d.DScantCancelar end = #form.FILTRO_NAPCANCEL#
	</cfif>
	<cfif form.FILTRO_DESCRIPCION NEQ "">
	   and upper(<cf_dbfunction name="spart" args="coalesce(ESobservacion, Observaciones);1;20" delimiters=";">) like '%#ucase(form.FILTRO_DESCRIPCION)#%'
	</cfif>
	<cfif form.FILTRO_SNNOMBRE NEQ "">
	   and upper(SNnombre) like '%#ucase(form.FILTRO_SNNOMBRE)#%'
	</cfif>
	<cfif form.chkOK EQ "1">
	   and upper(CMCMDresultado) NOT like 'OK%'
	</cfif>
	<cfif form.chkCANCEL EQ "1">
	   and upper(CMCMDresultado) NOT like '_C%EN ESTADO 60'
	   and upper(CMCMDresultado) NOT like 'OC%EN ESTADO -8'
	   and upper(CMCMDresultado) NOT like 'OC%EN ESTADO 55'
	   and upper(CMCMDresultado) NOT like 'OC%EN ESTADO 70'
	</cfif>
	<cfif form.FILTRO_CMCMDRESULTADO NEQ "">
	   and upper(CMCMDresultado) like '%#ucase(form.FILTRO_CMCMDRESULTADO)#%'
	</cfif>
	order by CMCMDtipo, CMCMDnumero
</cfquery>

<cfif rsDet.cantidad GT 0>
	<cfquery datasource="#session.DSN#">
		  update CMcancelacionMasivaDet
			 set CMCMDresultado = 'SC no existe' 
		 where Ecodigo		= #session.Ecodigo#
		   and CMCMid		= #form.CMCMid#
		   and CMCMDtipo	= 'SC' 
		   and (
				select count(1)
				  from ESolicitudCompraCM sc 
				 where sc.Ecodigo = CMcancelacionMasivaDet.Ecodigo 
				   and sc.ESnumero = CMcancelacionMasivaDet.CMCMDnumero 
				) = 0
	</cfquery>
	<cfquery datasource="#session.DSN#">
		  update CMcancelacionMasivaDet
			 set CMCMDresultado = 'OC no existe' 
		 where Ecodigo		= #session.Ecodigo#
		   and CMCMid		= #form.CMCMid#
		   and CMCMDtipo	= 'OC' 
		   and (
				select count(1)
				  from EOrdenCM oc 
				 where oc.Ecodigo	= CMcancelacionMasivaDet.Ecodigo 
				   and oc.EOnumero	= CMcancelacionMasivaDet.CMCMDnumero 
				) = 0
	</cfquery>
</cfif>
<cfoutput>
<form name="CMCancelMasiva" action="CancelacionMasiva-sql.cfm" method="post">
    <table border="0" cellpadding="0" cellspacing="0" width="100%" >
        <tr>
            <td width="180">
                Lote de Cancelación Masiva: 
            </td>
            <td width="10">
				<input type="hidden" name="CMCMid"   id="CMCMid"  value="#form.CMCMid#" />
                #rsform.CMCMid#
            </td>
            <td width="1">
                Fecha: 
            </td>
            <td align="right">
                #dateFormat(rsform.CMCMfecha,"DD/MM/YYYY")#
            </td>
        </tr>
        <tr>
            <td>
                Descripción: 
            </td>
            <td>
                <input name="CMCMdescripcion" type="text"  id="CMCMdescripcion"  value="#rsform.CMCMdescripcion#" size="80" maxlength="80" />
            </td>
            <td>
                Estado: 
            </td>
            <td align="right">
				<cfif rsform.CMCMejecutado EQ 1>
					EJECUTADO
				<cfelseif rsDet.cantidad EQ 0>
					NUEVO
				<cfelse>
					EN PROCESO
				</cfif>
            </td>
        </tr>
<cfif MODO EQ 'ALTA'>
        <tr>
            <td colspan="4">
                <cf_botones include="Regresar" modo="#MODO#">
            </td>
        </tr>
<cfelse>	
	<cfif rsDet.cantidad EQ 0>
        <tr>
            <td colspan="4">
                <cf_botones include="Regresar" modo="#MODO#">
            </td>
        </tr>
        <tr>
            <td colspan="2">
				<cf_sifimportar EIcodigo="CMCANCELMASI" mode="in">
					<cf_sifimportarparam name="CMCMid" value="#form.CMCMid#">
				</cf_sifimportar>
             </td>
        </tr>
	<cfelse>
		<cfif rsform.CMCMejecutado EQ 0>
			<tr>
				<td>
					Motivo de Cancelación: 
				</td>
				<td>
					<input name="CMCMmotivo" type="text"  id="CMCMmotivo"  value="" size="80" maxlength="80" />
				</td>
			</tr>
			<tr>
				<td colspan="4">
					<cf_botones exclude="BAJA" include="Regresar,Reimportar,CANCELACION_MASIVA" modo="#MODO#">
				</td>
			</tr>
		<cfelse>
			<tr>
				<td colspan="4">
					<cf_botones include="Reabrir,Regresar" exclude="CAMBIO,BAJA" modo="#MODO#">
				</td>
			</tr>
		</cfif>
        <tr>
            <td colspan="4">
				<input type="checkbox" name="chkOK" value="1" <cfif form.chkOK EQ 1>checked</cfif> onclick="javascript:filtrar_Plista();this.form.submit();"/>
				Quitar OK<BR />
				<input type="checkbox" name="chkCANCEL" value="1"  <cfif form.chkCANCEL EQ 1>checked</cfif> onclick="javascript:filtrar_Plista();this.form.submit();"/>
				Quitar Canceladas
				<cfinvoke component="sif.Componentes.pListas"
					method			="pListaQuery"
					query			="#rsFormDet#"
					returnvariable	="Lvar_Lista"
					desplegar		="CMCMDtipo,CMCMDnumero, NAPcancel, DSlinea, DScantCancelar, descripcion, fecha, Miso4217, total, SNnombre, CMCMDresultado"
					cortes			="TTipo"
					etiquetas		="Tipo,Numero, NAPcancel, Lin, DSCant, Descripcion, Fecha, Moneda, Total, Proveedor, Resultado"
					formatos		="S,S,S,S,M,S,D,S,M,S,S"
					filtro			="Ecodigo = #session.Ecodigo#"
					align			="left,left,left,left,left,left,right,right,right,left,left"
					keys			="CMCMDtipo, CMCMDnumero"
					maxrows			="25"
					showlink		="true"
					filtrar_automatico="false"
					mostrar_filtro	="true"
					incluyeform		="false"
					formname		="CMCancelMasiva"
					ira				="CancelacionMasiva.cfm"
					showemptylistmsg="true"
					ajustar			="N,N,N,N,N,N,N,N,N,N,S"
					debug			="N"
					funcion			="printSC_OC"
					fparams			="CMCMDtipo,CMCMDnumero,id,ESestado"
					navegacion		="#navegacion#"
				/>
            </td>
        </tr>
	</cfif>
</cfif>
    </table>
</form>
</cfoutput>

<script language="javascript">
	function funcCANCELACION_MASIVA()
	{
		if (document.getElementById("CMCMmotivo").value=="")
		{
			alert ("Debe digitar el Motivo de la Cancelación Masiva");
			document.getElementById("CMCMmotivo").focus();
			return false;
		}
	}
	function funcReimportar()
	{
		if (!confirm("¿Desea eliminar todos las SCs y OCs actuales?"))
		{
			return false;
		}
	}
	function funcReabrir()
	{
		if (!confirm("¿Desea volver a procesar todos las SCs y OCs que no se pudieron cancelar?"))
		{
			return false;
		}
	}

	var popUpWin = 0;

	function printSC_OC(tipo, num, id, est) {
		var params ="";
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		if (id == -1)
		{
			alert (tipo + ' ' + num + ' no existe');
			return false;
		}
		else if (tipo == 'OC')
			popUpWin = open("/cfmx/sif/cm/consultas/OrdenesCompra-vista.cfm?EOidorden="+id, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes');
		else if (tipo == 'SC')
			popUpWin = open("/cfmx/sif/cm/consultas/MisSolicitudes-vista.cfm?&ESidsolicitud="+id+"&ESestado="+est, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes');
	}

	document.getElementById("FILTROS_DSCANTCANCELAR").style.display = "none";
	document.getElementById("FILTROS_TOTAL").style.display = "none";
	document.getElementById("FILTRO_DSLINEA").style.display = "none";
	document.getElementById("FILTRO_FECHA").style.display = "none";
	document.getElementById("img_CMCancelMasiva_filtro_fecha").style.display = "none";
	document.getElementById("FILTRO_MISO4217").style.display = "none";
</script>