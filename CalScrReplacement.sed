# Copyright 2006-2010 Mesar Hameed, Emma Cliffe 
# 
# This file is part of LaTeXLex.
#
# LaTeXLex is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# LaTeXLex is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with LaTeXLex.  If not, see <http://www.gnu.org/licenses/>.
#
#
# The list of codes that you need is in the table but see note:
# http://www.w3.org/TR/MathML2/script.html
# The symbols were added at different times, those which start
# with a 0 display, to view those that start with 1 you will
# require a suitable font. A font is available from
# http://www.stixfonts.org/
# There is no difference between scr and cal in unicode and MathML
# I think that the best bet is to unify in LaTeXLex to \calA and \scrA 
# for instance but then map both to the same unicode with a warning
# if \cal and \scr are both in the same file
#
s/\\calA/𝒜/g #1D49C
s/\\calB/ℬ/g #0212C
s/\\calC/𝒞/g #1D49E
s/\\calD/𝒟/g #1D49F
s/\\calE/ℰ/g #02130
s/\\calF/ℱ/g #02131
s/\\calG/𝒢/g #1D4A2
s/\\calH/ℋ/g #0210B
s/\\calI/ℐ/g #02110
s/\\calJ/𝒥/g #1D4A5
s/\\calK/𝒦/g #1D4A6
s/\\calL/ℒ/g #02112
s/\\calM/ℳ/g #02133
s/\\calN/𝒩/g #1D4A9
s/\\calO/𝒪/g #1D4AA
s/\\calP/𝒫/g #1D4AB
s/\\calQ/𝒬/g #1D4AC
s/\\calR/ℛ/g #0211B
s/\\calS/𝒮/g #1D4AE
s/\\calT/𝒯/g #1D4AF
s/\\calU/𝒰/g #1D4B0
s/\\calV/𝒱/g #1D4B1
s/\\calW/𝒲/g #1D4B2
s/\\calX/𝒳/g #1D4B3
s/\\calY/𝒴/g #1D4B4 
s/\\calZ/𝒵/g #1D4B5 
s/\\scrA/𝒜/g #1D49C 
s/\\scrB/ℬ/g #0212C
s/\\scrC/𝒞/g #1D49E 
s/\\scrD/𝒟/g #1D49F 
s/\\scrE/ℰ/g #02130
s/\\scrF/ℱ/g #02131
s/\\scrG/𝒢/g #1D4A2  
s/\\scrH/ℋ/g #0210B
s/\\scrI/ℐ/g #02110
s/\\scrJ/𝒥/g #1D4A5 
s/\\scrK/𝒦/g #1D4A6 
s/\\scrL/ℒ/g #02112
s/\\scrM/ℳ/g #02133
s/\\scrN/𝒩/g #1D4A9 
s/\\scrO/𝒪/g #1D4AA 
s/\\scrP/𝒫/g #1D4AB 
s/\\scrQ/𝒬/g #1D4AC  
s/\\scrR/ℛ/g #0211B
s/\\scrS/𝒮/g #1D4AE  
s/\\scrT/𝒯/g #1D4AF 
s/\\scrU/𝒰/g #1D4B0 
s/\\scrV/𝒱/g #1D4B1 
s/\\scrW/𝒲/g #1D4B2 
s/\\scrX/𝒳/g #1D4B3 
s/\\scrY/𝒴/g #1D4B4 
s/\\scrZ/𝒵/g #1D4B5 

