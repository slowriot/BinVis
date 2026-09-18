#
#  Copyright (c) 2011 Robert Stephens 
#
#  This file is part of BinVis.
#
#  BinVis is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  BinVis is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with BinVis.  If not, see <http://www.gnu.org/licenses/>.
#

CXX ?= g++
PNG_CONFIG ?= libpng-config
PNG++VER := 0.2.5

CPP_FILES := hilbert.cpp pixel_assign.cpp pixel_generator.cpp bin_vis.cpp
CPP_OBJS := $(CPP_FILES:%.cpp=%.o)
CPP_DEPS := $(CPP_OBJS:%.o=%.d)

DEBUG ?= 0
ifeq ($(DEBUG), 1)
    CXXFLAGS ?= -g3 -DDEBUG
else
    CXXFLAGS ?= -O3 -DNDEBUG
endif

CPPFLAGS += -Ipng++-$(PNG++VER) $(shell $(PNG_CONFIG) --cflags)
LDLIBS += $(shell $(PNG_CONFIG) --ldflags)

.PHONY: all png++ test clean
all: bin_vis

bin_vis: $(CPP_OBJS)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $(CPP_OBJS) $(LDLIBS) -o $@

%.o: %.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -MMD -MP -c $< -o $@

png++:
	$(MAKE) -C png++-$(PNG++VER)

test:
	$(MAKE) -C test

clean:
	$(RM) $(CPP_OBJS) $(CPP_DEPS) bin_vis test/bin_out

-include $(CPP_DEPS)
