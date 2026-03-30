<cfif isdefined("Session.Usucodigo") and Len(trim(Session.Usucodigo)) GT 0>
	<cfquery name="rsNombre" datasource="asp">
		select Pnombre || '' || Papellido1 || '' || Papellido2 as nombre
		from Usuario a, DatosPersonales b
		where a.Usucodigo=#session.Usucodigo#
		and a.datos_personales=b.datos_personales
	</cfquery>
	<cfoutput>
	<cfif rsNombre.recordCount EQ 1>							

		<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" >
			<tr>
				<td nowrap valign="middle" align="right"><cf_boton texto="#rsNombre.nombre#" index="500" link="/cfmx/home/menu/micuenta/" 
																td_image_1="mb_r1_c2.gif|mb_r1_c2.gif|26|29"
																td_image_2="mb_r1_c2.gif|mb_r1_c2.gif|0|29|middle|Tahoma|14|##FFFFFF|bold"
																td_image_3="mb_r1_c2.gif|mb_r1_c2.gif|7|29"
																doevents="false"></td>
			</tr>
		</table>
		
	</cfif>		
	</cfoutput>
</cfif>