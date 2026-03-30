				<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta">
					Ecodigo="#rsArmaCuenta.Ecodigo#" 
					Cconcepto="#rsAsiento.Cconcepto#"
					Origen="LDVA "
                    Conexxion"#getConexion#"
					TipoDoc="#Tipo_Documento#"
					Cliente="##"
                    Sucursal="##"
                    Moneda="##"
                    Concepto"##"
				</cfinvoke>
                
                