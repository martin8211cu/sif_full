<cfoutput>
	<form name="formRepresentantes" method="get" action="#GetFileFromPath(GetTemplatePath())#">
		<cfinclude template="agente-hiddens.cfm">
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla="ISBpersonaRepresentante a
					inner join ISBpersona b
						on b.Pquien = a.Pcontacto"
			columnas="b.Pquien as Pquien_CT, b.Pid as Pid_CT, case b.Ppersoneria 
																when 'J' then  b.PrazonSocial
																else  rtrim(rtrim(b.Pnombre) || ' ' || rtrim(b.Papellido) || ' ' || b.Papellido2) end as Pnombre_CT"
			filtro="a.Pquien = #Form.Pquien#
					order by b.Pid, b.Pnombre"
			filtrar_por="b.Pid, case b.Ppersoneria 
								when 'J' then b.PrazonSocial
								else rtrim(rtrim(b.Pnombre) || ' ' || rtrim(b.Papellido) || ' ' || b.Papellido2) end"
			desplegar="Pid_CT, Pnombre_CT"
			etiquetas="Identificaci&oacute;n, Nombre"
			formatos="S,S"
			align="left,left"
			ira="#GetFileFromPath(GetTemplatePath())#"
			form_method="get"
			formName="formRepresentantes"
			keys="Pquien_CT"
			mostrar_filtro="yes"
			filtrar_automatico="yes"
			maxRows="0"
			pageIndex="rep"
		/>
	</form>
</cfoutput>
