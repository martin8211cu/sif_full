<cfif isdefined('url.RHPMid') and url.RHPMid NEQ '' and not isdefined('form.RHPMid')>
	<cfset form.RHPMid = url.RHPMid>
</cfif>

<cfinvoke 
	component="rh.Componentes.pListas" 
	method="pListaRH"
	returnvariable="rsLista"
	columnas="
		'' as colFan
		, Iid
		, im.RHPMid
		, a.DEid
		, a.DEidentificacion
		, (a.DEapellido1 + ' ' + a.DEapellido2 + ', ' + a.DEnombre) as nombreEmpl 
		, b.CIdescripcion
		, di.RHDMhorasautor
		, cm.RHCMfcapturada"
	desplegar="RHCMfcapturada,CIdescripcion, RHDMhorasautor,colFan"
	etiquetas="Fecha, Concepto de Incidencias, Horas Autorizadas, "
	tabla="
		IncidenciasMarcas im
			inner join DatosEmpleado a
				on a.DEid=im.DEid
		
			inner join RHDetalleIncidencias di
				on di.RHDMid = im.RHDMid
					and di.RHPMid = im.RHPMid
					and di.RHCMid = im.RHCMid							
					
			inner join CIncidentes b
				on b.CIid = im.CIid
				
			inner join RHControlMarcas cm
				on cm.RHCMid = im.RHCMid"
	filtro="
			a.Ecodigo = #Session.Ecodigo#
			and im.RHPMid = #form.RHPMid#
			and im.RetenerPago = 0
		order by nombreEmpl"
	mostrar_filtro="true"
	filtrar_automatico="true"
	filtrar_por="RHCMfcapturada,CIdescripcion,RHDMhorasautor,''"
	align="left,left,right,left"
	botones="Rechazar"
	Cortes="nombreEmpl"
	formatos="D,S,I,U"
	showLink="false"
	ira="aprobacionIncidencias-sql.cfm"
	checkboxes="S"
	debug="N"
	keys="Iid"
/>			

<script language="javascript" type="text/javascript">
	function hayAlgunoMarcado() {
		var form = document.lista;
		var result = false;
		if (form.chk!=null) {
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked)
						result = true;
				}
			}
			else{
				if (form.chk.checked)
					result = true;
			}
		}
		if (!result) {alert("Marque uno, o más registros, para realizar esta acción.");}
		return result;
	}

	function funcRechazar(){
		var result = false;
		if (hayAlgunoMarcado()){ 
			if(confirm("¿Desea Rechazar las incidencias seleccionadas ?")){
				document.lista.RHPMID.value = '<cfoutput>#form.RHPMid#</cfoutput>';
				result = true;
			}
		}	
		
		return result;
	};
	function funcFiltrar(){
		document.lista.RHPMID.value = '<cfoutput>#form.RHPMid#</cfoutput>';
		result = true;
	}
	
</script>