import {
  Tabs,
  TabList,
  TabTrigger,
  TabSlot,
  TabTriggerSlotProps,
  TabListProps,
} from 'expo-router/ui';
import { Pressable, View, StyleSheet, Text } from 'react-native';

export default function AppTabs() {
  return (
    <View style={styles.pageBackgroundContainer}>
      {/* Subtle Mathematical Coordinate Grid Motif */}
      <View style={styles.mathGridPattern} />

      {/* Sleek Mobile Device Container */}
      <View style={styles.mobilePhoneDevice}>
        {/* Notch Status Bar Header */}
        <View style={styles.notchHeaderBar}>
          <View style={styles.dynamicIslandNotch}>
            <View style={styles.cameraLens} />
          </View>
          <Text style={styles.deviceTimeText}>9:41</Text>
        </View>

        {/* Mobile Viewport Screen */}
        <Tabs style={styles.mobileViewportTabContainer}>
          <TabSlot style={{ flex: 1, backgroundColor: '#F8FAFC' }} />
          <TabList asChild>
            <CustomTabList>
              <TabTrigger name="home" href="/" asChild>
                <TabButton icon="🏠">Home</TabButton>
              </TabTrigger>
              <TabTrigger name="explore" href="/explore" asChild>
                <TabButton icon="📖">Learn</TabButton>
              </TabTrigger>
              <TabTrigger name="practice" href="/practice" asChild>
                <TabButton icon="✏️">Practice</TabButton>
              </TabTrigger>
              <TabTrigger name="parent" href="/parent" asChild>
                <TabButton icon="👨‍👩‍👧">Parent</TabButton>
              </TabTrigger>
              <TabTrigger name="settings" href="/settings" asChild>
                <TabButton icon="👤">Profile</TabButton>
              </TabTrigger>
            </CustomTabList>
          </TabList>
        </Tabs>

        {/* Smartphone Home Bar Indicator */}
        <View style={styles.bottomHomeBarArea}>
          <View style={styles.homeBarLine} />
        </View>
      </View>
    </View>
  );
}

export function TabButton({ children, icon, isFocused, ...props }: TabTriggerSlotProps & { icon?: string }) {
  return (
    <Pressable {...props} style={({ pressed }) => [styles.tabItemFlex, pressed && styles.pressedTab]}>
      <View style={[styles.tabButtonView, isFocused && styles.tabButtonActive]}>
        <Text style={[styles.tabIconEmoji, isFocused && styles.tabIconActive]}>{icon}</Text>
        <Text style={[styles.tabLabelText, isFocused && styles.tabLabelTextActive]}>
          {children}
        </Text>
      </View>
    </Pressable>
  );
}

export function CustomTabList(props: TabListProps) {
  return (
    <View {...props} style={styles.tabListWrapper}>
      <View style={styles.cleanTabContainer}>
        {props.children}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  pageBackgroundContainer: {
    flex: 1,
    backgroundColor: '#0F172A',
    justifyContent: 'center',
    alignItems: 'center',
    paddingVertical: 16,
    paddingHorizontal: 12,
    position: 'relative',
  },
  mathGridPattern: {
    position: 'absolute',
    top: 0,
    bottom: 0,
    left: 0,
    right: 0,
    opacity: 0.04,
    borderWidth: 1,
    borderColor: '#FFFFFF',
  },
  mobilePhoneDevice: {
    width: '100%',
    maxWidth: 430,
    height: '100%',
    maxHeight: 890,
    backgroundColor: '#F8FAFC',
    borderRadius: 40,
    borderWidth: 8,
    borderColor: '#1E293B',
    overflow: 'hidden',
    shadowColor: '#000000',
    shadowOffset: { width: 0, height: 16 },
    shadowOpacity: 0.5,
    shadowRadius: 28,
    position: 'relative',
  },
  notchHeaderBar: {
    height: 36,
    backgroundColor: '#FFFFFF',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 22,
    borderBottomWidth: 1,
    borderColor: '#E2E8F0',
    zIndex: 10,
  },
  dynamicIslandNotch: {
    width: 76,
    height: 16,
    backgroundColor: '#0F172A',
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
  },
  cameraLens: {
    width: 6,
    height: 6,
    borderRadius: 3,
    backgroundColor: '#172554',
  },
  deviceTimeText: {
    color: '#0F172A',
    fontSize: 11,
    fontWeight: '700',
  },
  mobileViewportTabContainer: {
    flex: 1,
    backgroundColor: '#F8FAFC',
  },
  tabListWrapper: {
    width: '100%',
    backgroundColor: '#FFFFFF',
    borderTopWidth: 1,
    borderColor: '#E2E8F0',
    paddingVertical: 8,
    paddingHorizontal: 6,
  },
  cleanTabContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-around',
    width: '100%',
  },
  tabItemFlex: {
    flex: 1,
    alignItems: 'center',
  },
  pressedTab: {
    opacity: 0.7,
  },
  tabButtonView: {
    alignItems: 'center',
    paddingVertical: 4,
    paddingHorizontal: 8,
    borderRadius: 10,
    backgroundColor: 'transparent',
  },
  tabButtonActive: {
    backgroundColor: '#EFF6FF',
  },
  tabIconEmoji: {
    fontSize: 16,
    opacity: 0.7,
  },
  tabIconActive: {
    opacity: 1,
  },
  tabLabelText: {
    color: '#64748B',
    fontSize: 10,
    fontWeight: '600',
    marginTop: 2,
  },
  tabLabelTextActive: {
    color: '#2563EB',
    fontWeight: '700',
  },
  bottomHomeBarArea: {
    height: 16,
    backgroundColor: '#FFFFFF',
    alignItems: 'center',
    justifyContent: 'center',
  },
  homeBarLine: {
    width: 120,
    height: 4,
    backgroundColor: '#94A3B8',
    borderRadius: 2,
  },
});
