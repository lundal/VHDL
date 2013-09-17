----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:56:35 09/17/2013 
-- Design Name: 
-- Module Name:    Toplevel - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Toplevel is
    Port ( SCU_Control : inout  STD_LOGIC_VECTOR (2 downto 0);
           SCU_Addr : in  STD_LOGIC_VECTOR (19 downto 0);
           SCU_Data : inout  STD_LOGIC_VECTOR (15 downto 0);
           SCU_Write : in  STD_LOGIC;
           SCU_Enable : in  STD_LOGIC;
           Inst_Addr : out  STD_LOGIC_VECTOR (18 downto 0);
           Inst_Data : inout  STD_LOGIC_VECTOR (31 downto 0);
           Inst_Write : out  STD_LOGIC;
           Inst_Enable : out  STD_LOGIC;
           Data_Addr : out  STD_LOGIC_VECTOR (18 downto 0);
           Data_Data : inout  STD_LOGIC_VECTOR (15 downto 0);
           Data_Write : out  STD_LOGIC;
           Data_Enable : out  STD_LOGIC;
			  Clock : in STD_LOGIC;
			  Reset : in STD_LOGIC
			);
end Toplevel;

architecture Behavioral of Toplevel is

begin


end Behavioral;

