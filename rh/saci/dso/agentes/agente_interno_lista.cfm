<cfinclude template="agente-params.cfm">

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
			union
			select '2' as value, 'Borrado' as description, '1' as ord
			order by 3,2
		</cfquery>
		<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO Tipo--->
		<cfquery datasource="#session.dsn#" name="rsPpersoneria">
			select '' as value, '-- todos --' as description, '0' as ord
			union
			select a.Ppersoneria as value, ltrim(rtrim(a.Pdescripcion)) as description, '1' as ord
			from ISBtipoPersona a
			Where Ppersoneria != 'R'
			order by 3,2
		</cfquery>

		<!--- LISTA DEL MANTENIMIENTO --->
			<cfinvoke 
			 component="sif.Componentes.pListas" 
			 method="pLista">
				<cfinvokeargument name="tabla" value="ISBagente a 
														inner join ISBpersona b
														on b.Ecodigo = a.Ecodigo
														and b.Pquien = a.Pquien	"/>
				<cfinvokeargument name="columnas" value="a.AGid as ag, a.Pquien as pq, b.Pid,
														case a.Habilitado 
															when 1 then '<a href=''##'' onclick=''javascript: return habDeshab(""' || convert(varchar, a.AGid) || '"",""1"");''><img src=''/cfmx/saci/images/checked.gif'' border=''0''>&nbsp;</a>'
															when 0 then '<a href=''##'' onclick=''javascript: return habDeshab(""' || convert(varchar, a.AGid) || '"",""0"");''><img src=''/cfmx/saci/images/unchecked.gif'' border=''0''>&nbsp;</a>' 
														end as HabilitadoCob,
														case a.Habilitado
															when 1 then 'Habilitado'
															when 0 then 'Inhabilitado'
															when 2 then '(Borrado)'
														end as Habilitado,
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
														case a.AAinterno
															when 0 then 'Externo'
															when 1 then 'Interno' end
															 as tipo,	
														'0' as Cambiar,
														'1' as tab"/> 
				<cfinvokeargument name="desplegar" value="ag,Ppersoneria,Pid,nom_razon,HabilitadoCob,Habilitado"/>
				<cfinvokeargument name="etiquetas" value="Código,Personería,Identificación,Nombre,Habilitar/Desabilitar,Estado"/>
				<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo#
														and AAinterno = 1
														order by AGid"/>
				<cfinvokeargument name="align" value="left,left,left,left,left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="agente_interno.cfm"/>
				<cfinvokeargument name="botones" value="Agregar"/>
				<cfinvokeargument name="conexion" value="#Session.DSN#"/>
				<cfinvokeargument name="keys" value="ag"/>
				<cfinvokeargument name="formatos" value="I,S,S,S,S,S"/>
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>
				<cfinvokeargument name="filtrar_por" value="a.AGid,b.Ppersoneria,b.Pid,
														case b.Ppersoneria 
															when 'J' then b.PrazonSocial
															else rtrim(rtrim(b.Pnombre) || ' ' || rtrim(b.Papellido) || ' ' || b.Papellido2) end
														,case a.AAinterno
														    when 0 then 'Externo'
															when 1 then 'Interno' end
														,a.Habilitado"/>
				<cfinvokeargument name="rshabilitado" value="#rsHabilitado#"/>
				<cfinvokeargument name="rsppersoneria" value="#rsPpersoneria#"/>
				<cfinvokeargument name="maxrows" value="15"/>
				<cfinvokeargument name="PageIndex" value="root"/>
				<cfinvokeargument name="formName" value="listaAgentes"/>
				<cfinvokeargument name="form_method" value="get"/>
			</cfinvoke>	
	</td>
  </tr>
</table>
<br />
<cfoutput>
	<script language="JavaScript" type="text/javascript" >
		function funcAgregar() {
			location.href = "agente_interno.cfm?tab=1&tipo=Interno";
			return false;
		}

		function habDeshab(AGid,Hab){
			var mensaje = "";
			if(Hab == 1)
				mensaje = "Inhabilitar";
			else
				mensaje = "habilitar";
				
			if (confirm("Desea " + mensaje + " el agente ?")) {
				document.listaAgentes.action = "agente_lista-apply.cfm?tipo=Interno";
				document.listaAgentes.method = "post";
				document.listaAgentes.AG.value = AGid;				
				document.listaAgentes.CAMBIAR.value = 1;
				if(Hab == 1)
					document.listaAgentes.HABILITADO.value = 0;
				else
					document.listaAgentes.HABILITADO.value = 1;
				document.forms["listaAgentes"].nosubmit=true;
				document.listaAgentes.submit();
			}else{
				document.forms["listaAgentes"].nosubmit=true;
				return false;				
			}
		}
	</script>
</cfoutput>
