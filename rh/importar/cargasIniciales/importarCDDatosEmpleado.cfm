<cfquery datasource="#session.DSN#">
	insert into CDRHDatosEmpleado  (CDRHDEidentificacion, CDRHDEnombre, CDRHDEapellido1, CDRHDEapellido2, CDRHDEtipoidentificacion, 
									CDRHDEecivil, CDRHDEfnacimiento, CDRHDEsexo, CDRHDEdireccion, CDRHDEbanco,
									CDRHDEcuenta, CDRHDEcbcc, CDRHDEtelefono1, CDRHDEtelefono2, CDRHDEcorreo, 
									CDRHDEtarjeta, CDRHDEdatovarpeq1, CDRHDEdatovarpeq2, CDRHDEdatovarpeq3, 
									CDRHDEdatovarpeq4, CDRHDEdatovarpeq5, CDRHDEdatovarpeq6,CDRHDEdatovarpeq7, 
                                    CDRHDEdatovarmed1, CDRHDEdatovarmed2, CDRHDEdatovarmed3, CDRHDEdatovarmed4, CDRHDEdatovarmed5,
									CDRHDEdatovargde1, CDRHDEdatovargde2, CDRHDEdatovargde3, CDRHDEdatovargde4, CDRHDEdatovargde5,
									CDRHDEtipocuenta, Ecodigo, CDRHDEcarneseguro,CDRHDEsdi,CDRHDEtiposalario,CDRHDEtipocontratacion,CDRHDEtipoempleado,
                                    CDRHDErfc,CDRHDEcurp,CDRHDEzeid,CDRHDEnacionalidad)
	select 	identificacion,nombre,apellido1,apellido2,tipoidentificacion,
			estadocivil,fechanacimiento,sexo,direccion,idbanco,
			cuentadepositos,cuentacliente,telefonoresidencia,telefonocelular,correoelectronico,
			tarjetamarcas,dvariablepeq1,dvariablepeq2,dvariablepeq3,
			dvariablepeq4,dvariablepeq5,dvariablepeq6,dvariablepeq7,
            dvariablemed1,dvariablemed2,dvariablemed3,dvariablemed4,dvariablemed5,
			dvariablegde1,dvariablegde2,dvariablegde3,dvariablegde4,dvariablegde5,
			tipocuenta, #session.Ecodigo#,carnesegurosocial,DEsdi,tiposalario,tipocontrato,tipoempleado,
            RFC,CURP,ZEid,nacionalidad
	from #table_name#	
</cfquery>