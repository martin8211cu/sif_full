<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.codigo") and len(trim(url.codigo))>
	<cfquery name="rs" datasource="#session.DSN#">
		select
				c.Ccuenta, 
				c.Cformato, 
				c.Cdescripcion, 
				case m.Ctipo 
					when 'A' then 'Activo' 
					when 'P' then 'Pasivo' 
					when 'C' then 'Capital' 
					when 'I' then 'Ingreso' 
					when 'G' then 'Gasto' 
					else 'Orden' 
				end as Ctipo
			from CContables c 
				inner join CtasMayor m 
				  on m.Cmayor = c.Cmayor 
				 and m.Ecodigo = c.Ecodigo
			where
			c.Cformato = '#url.codigo#'
			and c.Ecodigo = #session.Ecodigo#
			and c.Cformato <> c.Cmayor
			and c.Cmovimiento = 'S'
			and not exists(
						select 1
						from CGIC_Cuentas mc
						where mc.Ccuenta = c.Ccuenta
						and mc.CGICMid = #url.CGICMid#
							)
			
			order by c.Cformato
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.Ccuenta#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.numero#</cfoutput>.value="<cfoutput>#rs.Cdescripcion#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#rs.Cformato#</cfoutput>";
			<cfoutput>if (window.parent.func#url.numero#) {window.parent.func#url.numero#()}</cfoutput>
		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.numero#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
			<cfoutput>if (window.parent.func#url.numero#) {window.parent.func#url.numero#()}</cfoutput>
		</script>
	</cfif>
</cfif>