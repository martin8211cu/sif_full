
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif isdefined("Session.Ecodigo") and isdefined("Form.TCNum") and not isDefined("Form.Nuevo")>
	<cfset modo="CAMBIO">
</cfif>

<cfset cambio = false>
<cfif modo eq "CAMBIO">
	<cfset cambio = true>
	<cfquery name="rsCuenta" datasource="#session.DSN#">
		select '1' as '1'
			,	concat(d.DEnombre,' ',d.DEapellido1,' ',d.DEapellido2) as GDEnombreC
			,	d.DEidentificacion GDEidentificacion
			,	c.DatosEmpleadoDEid GDEid
			,	concat(d2.DEnombre,' ',d2.DEapellido1,' ',d2.DEapellido2) as ADEnombreC
			,	d2.DEidentificacion ADEidentificacion
			,	c.DatosEmpleadoDEid2 ADEid
			,	c.Tipo
			,	c.numero
			,	c.id
			,	case c.Tipo
					when 'D' then 'Vales'
					when 'TC' then 'Tarjeta de Credito'
					when 'TM' then 'Tarjeta Mayorista'
					else ''
				end as TipoDescripcion
			,	case tc.Estado
					when 'A' then 'Activa'
					when 'G' then 'Generada'
					when 'C' then 'Cancelada'
					when 'X' then 'Anulada'
					else ''
				end as EstadoDescripcion
			,	tc.Estado
			,	tc.Numero as TCNum
			,	case 
					when tc.CRCTarjetaAdicionalid is NULL then 'Titular'
					else 'Adicional' end as Adicional
			,	s.SNnombre
			,	s.SNidentificacion
			,	s.SNfechaNacimiento
			,	s.SNtelefono
			,	s.SNemail
			,	dr.Direccion1 as dirDireccion1
			,	dr.Direccion2 as dirDireccion2
			,	dr.Ciudad as dirCiudad
			,	dr.Estado as dirEstado
			,	dr.CodPostal as dirCodPostal
			,	dr.pPais as dirpPais
			,	tc.MotivoCancelado
			,	tc.updatedat
			,	tc.FolioCancelado
			,	c.MontoAprobado
			,	s.SNFecha
		from CRCCuentas c
			inner join SNegocios s 
				on c.SNegociosSNid = s.SNid
			inner join CRCEstatusCuentas ce 
				on c.CRCEstatusCuentasid = ce.id
			left join CRCCategoriaDist cd 
				on c.CRCCategoriaDistid = cd.id
			left join DatosEmpleado d 
				on c.DatosEmpleadoDEid = d.DEid
			left join DatosEmpleado d2 
				on c.DatosEmpleadoDEid2 = d2.DEid
			left join DireccionesSIF dr
				on s.id_direccion = dr.id_direccion
			inner join CRCTarjeta tc
				<cfif isDefined('form.Estado') && form.Estado eq 'X'>
					on tc.oldCRCCuentasid = c.id
				<cfelse>
					on tc.CRCCuentasid = c.id
				</cfif>
		where c.Ecodigo = #Session.Ecodigo#
			and tc.Numero = '#form.TCNum#'
	</cfquery>
</cfif>

<cfoutput>

<table width="80%">
	<tr>
		<td>
			<div name="dashboardTabs" width="80%">
				<cf_tabs width="80%">
					<cf_tab text="Tarjeta" selected>
						<cf_web_portlet_start border="true"  titulo="Tarjeta" >
							<cfinclude template="GestionTarjeta_TabForm.cfm"> 
						<cf_web_portlet_end>
					</cf_tab>
					<cf_tab text="Informacion">
						<cf_web_portlet_start border="true" titulo="Informacion" >
							<cfinclude template="GestionTarjeta_TabInfo.cfm">
						<cf_web_portlet_end>
					</cf_tab>
				</cf_tabs>
			</div>
		</td>
	</tr>
</table>

</cfoutput>

<script type="text/javascript">

	document.getElementsByName('dashboardTabs')[0].children[0].appendChild(document.getElementById('tab2c'));

	function soloNumeros(e) {
		var keyCode = e.charCode;
		if(keyCode >= 45 && keyCode <= 57 && keyCode != 47)
        return true;
         
        return /\d/.test(String.fromCharCode(keynum));
	}

	$('.decimalInput').keypress(function(eve) {
  		if ((eve.which != 8 && eve.which != 0) && (eve.which != 46 || $(this).val().indexOf('.') != -1) && (eve.which < 48 || eve.which > 57) || (eve.which == 46 && $(this).caret().start == 0) ) {
	    	eve.preventDefault();
	  	}
	});

	// this part is when left part of number is deleted and leaves a . in the leftmost position. For example, 33.25, then 33 is deleted
 	$('.decimalInput').keyup(function(eve) {
  		if($(this).val().indexOf('.') == 0) {
  			$(this).val($(this).val().substring(1));
  		}
 	});

	function funcEliminar(){ return confirm("Esta seguro que quiere CANCELAR la tarjeta?");}
	function funcAplicar(){ return confirm("Esta seguro que quiere ACTIVAR la tarjeta?");}
	function funcRegresar(){ return confirm("Esta seguro que quiere REACTIVAR la tarjeta?");}

</script>
