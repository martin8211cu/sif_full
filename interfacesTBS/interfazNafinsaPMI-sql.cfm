<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cancelacion de Documentos'>

<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="900">
<cf_navegacion name="FechaI" 		navegacion="" session default="">

<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>

<cfset varNavegacion = "?FechaI=#form.FechaI#">
<cfif isdefined("url.PageNum_lista") and len(trim(url.PageNum_lista)) GT 0>
	<cfset varNavegacion = varNavegacion & "&pagina=#url.PageNum_lista#">
<cfelse>
	<cfset varNavegacion = varNavegacion & "&pagina=1">
</cfif>
<cfsetting enablecfoutputonly="yes">

<cfparam name="FechaI" default="">

<cfset Session.FechaVen = #vFechaI#>

<cfoutput>
	<cfquery name="rsDocumentosCancelar" datasource="#session.dsn#">
		select distinct SN.SNcodigoext, TESSPid, EP.TESOPid,
		DP.TESDPdocumentoOri ,         convert(varchar,EP.TESOPfechaGeneracion, 103) as TESOPfechaGeneracion,
		TESDPfechaVencimiento = (select top 1 convert(varchar, DP.TESDPfechaVencimiento, 103)where DP.TESSPid = TESSPid),        '01' as Mcodigo,
		MontoPago = (select sum(TESDPmontoPago) from TESdetallePago where TESOPid = DP.TESOPid and TESSPid = DP.TESSPid), 	        'N' as Tipo_Factoraje, '', convert(varchar,EP.TESOPfechaGeneracion,103), 'D' as Tipo_Compra,
		(select top 1 Rubro = case DD.DDtipo
							  when 'S' then (select substring (cuentac,1,5) from Conceptos where Cid = DD.DDcoditem and                              substring (cuentac,1,5) != 39908) 
							  when 'F' then (select substring (cuentac,1,5) from Conceptos where Ccodigo = 'AF' and                              substring (cuentac,1,5) != 39908) 
							 end 
		 from TESordenPago O
		 inner join TESdetallePago D on D.TESOPid = O.TESOPid
		 inner join HEDocumentosCP CP on CP.IDdocumento = D.TESDPidDocumento
		 inner join HDDocumentosCP DD on DD.IDdocumento  = CP.IDdocumento
		 where  O.TESOPid = EP.TESOPid
		 and D.TESDPtipoDocumento = 1
		 and NOT (TESDPmontoAprobadoOri <= 0 and TESDPdescripcion like '- Credito:%')  
		 and D.RlineaId is null and D.MlineaId is null) as Rubro, 
		 datediff(dd, EP.TESOPfechaGeneracion, DP.TESDPfechaVencimiento) as Plazo_Pago 
		 from TESordenPago EP
 		 inner join TESdetallePago DP on EP.TESOPid = DP.TESOPid
		 inner join SNegocios SN on SN.SNid = EP.SNid and EP.EcodigoPago = SN.Ecodigo
		 where TESOPestado != 10 and TESOPestado != 13
		 and EP.Miso4217Pago = 'MXP'
		 -----and EP.Miso4217Pago = DP.Miso4217Ori		
		 and Integracion = 1 
		 and TESDPmoduloOri = 'CPFC'
		 and TESDPfechaVencimiento =  #vFechaI#		
		 order by TESSPid, TESDPdocumentoOri
	</cfquery>
</cfoutput> 

<cfoutput>
 <table>
    <tr>
		<tr> 
		<td width="50">&nbsp;</td>
            <td width="100000"><strong><br>Pagos: </br><strong/></td> </td> 
            <td colspan="2">
			</tr>
	    	<td align="justify" colspan="4"  width="600" height="30">
            	</tr></tr>
            </td>					
		</tr>		   
       <cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsDocumentosCancelar#"/>
			<cfinvokeargument name="cortes" value=""/>
			<cfinvokeargument name="desplegar" value="TESOPid,SNcodigoext, TESDPdocumentoOri, TESOPfechaGeneracion,  TESDPfechaVencimiento, Mcodigo, MontoPago, TESOPfechaGeneracion, Rubro, Plazo_Pago"/>
			<cfinvokeargument name="etiquetas" value="OrdenPago,Socio,Documento,FechaOrden, FechaVencimiento, Moneda,Monto,FechaRecepción,Rubro, PlazoPago"/>
			<cfinvokeargument name="formatos" value="S,S,S,S,S,S,S,S,S,S"/>
			<cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N,N,N,N"/>
			<cfinvokeargument name="align" value="center,center, center, center, center, center, left, center, center, center"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="irA" value="interfazNafinsaPMI-Genera.cfm"/>   
            <cfinvokeargument name="MaxRows" value="20"/>
			<cfinvokeargument name="showLink" value="false"/>
			<cfinvokeargument name="keys" value="TESDPfechaVencimiento"/>
			<cfinvokeargument name="botones" value="Generar,Regresar"/>
            <cfinvokeargument name="navegacion" value=""/>
            <cfinvokeargument name="inactivecol" value=""/>
		</cfinvoke>
</table>

<cfset session.ListaReg = #rsDocumentosCancelar#>
<script type="text/javascript">
function algunoMarcado(){
		var aplica = false;
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				aplica = document.lista.chk.checked;
			}else{
				for (var i=0; i<document.lista.chk.length; i++) {
					if (document.lista.chk[i].checked) { 
						aplica = true;
						break;
					}
				}
			}
		}
		if (aplica) {
			return (confirm("¿Aplicar Registros seleccionados?"));
		} else {
			alert('Debe seleccionar al menos un documento antes de Aplicar');
			return false;
		}
	}

<!---function funcGenerar() {
		if (algunoMarcado())
			document.lista.action = "interfazNafinsaPMI-Genera.cfm";
		else
			return false;
	}
	--->
function Marcar(c) {
		if (c.checked) {
			for (counter = 0; counter < document.lista.chk.length; counter++)
			{				if ((!document.lista.chk[counter].checked) && (!document.lista.chk[counter].disabled))
					{  document.lista.chk[counter].checked = true;}
			}
			if ((counter==0)  && (!document.lista.chk.disabled)) {
				document.lista.chk.checked = true;
			}
		}
		else {
			for (var counter = 0; counter < document.lista.chk.length; counter++)
			{
				if ((document.lista.chk[counter].checked) && (!document.lista.chk[counter].disabled))
					{  document.lista.chk[counter].checked = false;}
			};
			if ((counter==0) && (!document.lista.chk.disabled)) {
				document.lista.chk.checked = false;
			}
		};
	}
	
function funcRegresar() {
			document.lista.action = "InterfazNafinsaPMI-Param.cfm";		
		}
</script>
</cfoutput> 



