<cfif Len(session.saci.agente.id) is 0 or session.saci.agente.id is 0>
  <cfthrow message="Usted no está registrado como agente autorizado, por favor verifíquelo.">
</cfif>

<cfinclude template="vendedor-params.cfm">

<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
	<td>
		
		<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO HABILITADO--->
		<cfquery datasource="#session.dsn#" name="rsHabilitado">
			select '' as value, '-- todos --' as description, '0' as ord
			union
			select '0' as value, 'Inhabilitado' as description, '1' as ord
			union
			select '1' as value, 'Habilitado' as description, '1' as ord
			order by 3,2
		</cfquery>
		<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO Tipo--->
		<cfquery datasource="#session.dsn#" name="rsPpersoneria">
			select '' as value, '-- todos --' as description, '0' as ord
			union
			select a.Ppersoneria as value, ltrim(rtrim(a.Pdescripcion)) as description, '1' as ord
			from ISBtipoPersona a
			order by 3,2
		</cfquery>

		<!--- LISTA DEL MANTENIMIENTO --->
		<cfinvoke 
		 component="sif.Componentes.pListas" 
		 method="pLista">
			<cfinvokeargument name="tabla" value="ISBvendedor a 
													inner join ISBpersona b
													on b.Pquien = a.Pquien	"/>
			<cfinvokeargument name="columnas" value="a.Vid as ven, a.Pquien as pq, b.Pid,
													case a.Habilitado 
														when 1 then '<a href=''##'' onclick=''javascript: return habDeshab(""' || convert(varchar, a.Vid) || '"",""1"");''><img src=''/cfmx/saci/images/checked.gif'' border=''0''></a>'
													else 
														'<a href=''##'' onclick=''javascript: return habDeshab(""' || convert(varchar, a.Vid) || '"",""0"");''><img src=''/cfmx/saci/images/unchecked.gif'' border=''0''></a>'
													end as HabilitadoCob,
													a.Habilitado,
													case b.Ppersoneria 
														when 'J' then 'Jurídica Nacional'
														when 'F' then 'Fisica Nacional'
														when 'E' then 'Extranjero'
														when 'R' then 'Extranjero Residente'
														end as Ppersoneria,
													case b.Ppersoneria 
														when 'J' then  b.PrazonSocial
														else  rtrim(rtrim(b.Pnombre) || ' ' || rtrim(b.Papellido) || ' ' || b.Papellido2) end
														as nom_razon,
													'' as Cambio,
													'1' as tab"/> 
			<cfinvokeargument name="desplegar" value="Ppersoneria,Pid,nom_razon,HabilitadoCob"/>
			<cfinvokeargument name="etiquetas" value="Tipo,Identificación,Nombre,Estado"/>
			<cfinvokeargument name="filtro" value="a.AGid = #session.saci.agente.id#
													order by b.Ppersoneria, b.Pid, nom_razon"/>
			<cfinvokeargument name="align" value="left,left,left,left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="irA" value="vendedor.cfm"/>
			<cfinvokeargument name="botones" value="Nuevo"/>
			<cfinvokeargument name="conexion" value="#Session.DSN#"/>
			<cfinvokeargument name="keys" value="ven"/>
			<cfinvokeargument name="formName" value="listaVendedores"/>
			<cfinvokeargument name="form_method" value="get"/>
			<cfinvokeargument name="formatos" value="S,S,S,S"/>
			<cfinvokeargument name="mostrar_filtro" value="true"/>
			<cfinvokeargument name="filtrar_automatico" value="true"/>
			<cfinvokeargument name="filtrar_por" value=" b.Ppersoneria,b.Pid,
													case b.Ppersoneria 
														when 'J' then b.PrazonSocial
														else rtrim(rtrim(b.Pnombre) || ' ' || rtrim(b.Papellido) || ' ' || b.Papellido2) end
													,a.Habilitado"/>
			<cfinvokeargument name="rshabilitadocob" value="#rsHabilitado#"/>
			<cfinvokeargument name="rsppersoneria" value="#rsPpersoneria#"/>
			<cfinvokeargument name="maxrows" value="15"/>
			<cfinvokeargument name="PageIndex" value="root"/>
		</cfinvoke>	

	</td>
  </tr>
</table>

<cfoutput>
	<script language="JavaScript" type="text/javascript" >
		function funcNuevo() {
			location.href = "vendedor.cfm?tab=1";
			return false;
		}
		function habDeshab(Vid,Hab){
			var mensaje = "";
			if(Hab == 1)
				mensaje = "Inhabilitar";
			else
				mensaje = "habilitar";
				
			if (confirm("Desea " + mensaje + " el Vendedor ?")) {
				document.listaVendedores.action = "vendedor_lista-apply.cfm";
				document.listaVendedores.method = "post";
				document.listaVendedores.CAMBIO.value = "1";
				document.listaVendedores.VEN.value = Vid;
				if(Hab == 1)
					document.listaVendedores.HABILITADO.value = 0;
				else
					document.listaVendedores.HABILITADO.value = 1;
				document.listaVendedores.submit();
			}else{
				document.forms["listaVendedores"].nosubmit=true;
				return false;				
			}
		}				
	</script>
</cfoutput>
