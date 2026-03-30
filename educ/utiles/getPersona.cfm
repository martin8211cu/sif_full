<cfif isdefined("url.usr") and Len(Trim(url.usr)) NEQ 0>
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	<cfset u = sec.getUsuarioByRef(url.usr, Session.EcodigoSDC, 'PersonaEducativo')>

	<cfoutput>
		<script language="JavaScript" type="text/javascript">
			if (parent.id != null) parent.id.value = "#u.Pid#";
			if (parent.nombre != null) parent.nombre.value = "#u.Pnombre#";
			if (parent.apellido1 != null) parent.apellido1.value = "#u.Papellido1#";
			if (parent.apellido2 != null) parent.apellido2.value = "#u.Papellido2#";
			if (parent.nacimiento != null) parent.nacimiento.value = "#LSDateFormat(u.Pnacimiento,'dd/mm/yyyy')#";
			if (parent.sexo != null) parent.sexo.value = "#u.Psexo#";
			if (parent.casa != null) parent.casa.value = "#u.Pcasa#";
			if (parent.oficina != null) parent.oficina.value = "#u.Poficina#";
			if (parent.celular != null) parent.celular.value = "#u.Pcelular#";
			if (parent.fax != null) parent.fax.value = "#u.Pfax#";
			if (parent.pagertel != null) parent.pagertel.value = "#u.Ppagertel#";
			if (parent.pagernum != null) parent.pagernum.value = "#u.Ppagernum#";
			if (parent.email1 != null) parent.email1.value = "#u.Pemail1#";
			if (parent.email2 != null) parent.email2.value = "#u.Pemail2#";
			if (parent.web != null) parent.web.value = "#u.Pweb#";
		</script>
	</cfoutput>
</cfif>
